import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:collection/collection.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../../../product_list/data/models/product_model.dart';
import '../models/home_category_model.dart';
import '../models/home_response.dart';
import '../models/section_model.dart';
import '../models/slider_model.dart';
import '../../../../core/utils/extensions_app/html/html_extensions.dart';

class ManagedHomeRemoteDataSource with ApiClient {
  /// 🚀 Entry point: Fetch and reconcile all home data
  Future<Either<HelperResponse, HomeResponse>> getHome() async {
    final results = await Future.wait([
      graphQLQuery(
        'query { cmsPage(identifier: "home") { content } }',
        dataKey: 'cmsPage',
        fromJson: (json) => json as Map<String, dynamic>,
      ),
      _fetchCategories(),
    ]);

    final cmsRes = results[0] as Either<HelperResponse, Map<String, dynamic>>;
    final catRes =
        results[1] as Either<HelperResponse, List<HomeCategoryModel>>;

    return cmsRes.fold((error) => Left(error), (data) async {
      final doc = _parseHtml(data['content'] ?? '');
      final sections = _extractSections(doc);
      final cats = catRes.getOrElse(() => []);

      // Discover products from sections
      final info = _extractProductIdentity(doc, sections);
      final apiProds = (await _fetchProductsBatch(
        info['uids']!,
        info['names']!,
      )).getOrElse(() => []);

      return Right(
        HomeResponse(
          sliders: doc.mapQuery(
            '.magicslider img',
            (img) => HomeSliderModel(
              image: img.attr('src'),
              width: int.tryParse(img.attr('width')) ?? 0,
              height: int.tryParse(img.attr('height')) ?? 0,
            ),
          ),
          sections: sections,
          categories: _reconcileCategories(doc, cats),
          promotionalBanners: _extractBanners(doc, cats),
          bestSellerProducts: _reconcileProds(
            doc,
            sections,
            apiProds,
            HomeSectionType.bestSeller,
          ),
          mostSearchedProducts: _reconcileProds(
            doc,
            sections,
            apiProds,
            HomeSectionType.mostSearched,
          ),
          newArrivalsProducts: _reconcileProds(
            doc,
            sections,
            apiProds,
            HomeSectionType.newArrivals,
          ),
          specialOffersProducts: _reconcileProds(
            doc,
            sections,
            apiProds,
            HomeSectionType.specialOffers,
          ),
        ),
      );
    });
  }

  // --- CMS & Sections ---
  Document _parseHtml(String raw) => parse(
    raw
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&#13;', '\r')
        .replaceAll('&#10;', '\n')
        .replaceAll('&nbsp;', ' '),
  );

  List<HomeSectionModel> _extractSections(Document d) =>
      d.mapQuery('.magictabs[data-ajax]', (t) {
        final data = jsonDecode(t.attr('data-ajax'));
        final id = (data['identifier'] as String? ?? '').toLowerCase();
        final lim = int.tryParse(data['limit']?.toString() ?? '10') ?? 10;

        final title = _findTitle(t);
        final isSpecial =
            title.contains('عروض') ||
            title.contains('special') ||
            title.contains('offer');

        if (id.contains('bestseller') && !isSpecial)
          return HomeSectionModel(
            type: HomeSectionType.bestSeller,
            title: title.isNotEmpty ? title : 'الأفضل مبيعاً',
            meta: {'identifier': id, 'limit': lim},
          );
        if (id.contains('new') || id.contains('latest'))
          return HomeSectionModel(
            type: HomeSectionType.newArrivals,
            title: title.isNotEmpty ? title : 'وصل حديثاً',
            meta: {'identifier': id, 'limit': lim},
          );
        if (isSpecial || title.contains('عروض') || id.contains('special'))
          return HomeSectionModel(
            type: HomeSectionType.specialOffers,
            title: title.isNotEmpty ? title : 'عروض خاصة',
            meta: {'identifier': id, 'limit': lim},
          );

        return HomeSectionModel(
          type: HomeSectionType.mostSearched,
          title: title.isNotEmpty ? title : 'الأكثر بحثاً',
          meta: {'identifier': id, 'limit': lim},
        );
      });

  String _findTitle(Element t) {
    final selectors = [
      '.title',
      'h2.title',
      'h3.title',
      '.cms-title .title',
      '.magic-category .title',
    ];
    for (var s in selectors) {
      final txt = t.parent?.getText(s) ?? t.parent?.parent?.getText(s) ?? '';
      if (txt.isNotEmpty) return txt.trim();
    }
    return '';
  }

  // --- Products ---
  Map<String, List<String>> _extractProductIdentity(
    Document doc,
    List<HomeSectionModel> sections,
  ) {
    final ids = <String>{}, names = <String>{};
    for (var s in sections) {
      final cont = _findCont(doc, s);
      if (cont == null) continue;
      for (var item in cont.querySelectorAll(
        '.product-item-info, .item.product',
      )) {
        final id = _getId(item),
            n = item.getText('.product-name a, .product-item-link');
        if (id.isNotEmpty) ids.add(id);
        if (n.isNotEmpty) names.add(n);
      }
    }
    return {'uids': ids.toList(), 'names': names.toList()};
  }

  Future<Either<HelperResponse, List<ProductModel>>> _fetchProductsBatch(
    List<String> uids,
    List<String> names,
  ) async {
    if (uids.isEmpty && names.isEmpty) return const Right([]);
    final realSkus = uids
        .where((u) => u.length > 2 && int.tryParse(u) == null)
        .toList();
    final ids = uids.where((u) => int.tryParse(u) != null).toList();

    final queries = <String>[];
    const frag =
        'fragment P on ProductInterface { __typename uid id sku name stock_status small_image { url } ... on SimpleProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } special_price new_from_date new_to_date } ... on ConfigurableProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } special_price new_from_date new_to_date } ... on VirtualProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } special_price new_from_date new_to_date } ... on DownloadableProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } special_price new_from_date new_to_date } ... on BundleProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } special_price new_from_date new_to_date } ... on GroupedProduct { price_range { minimum_price { regular_price { value currency } final_price { value currency } discount { amount_off percent_off } } } } }';

    if (realSkus.isNotEmpty)
      queries.add(
        'skus: products(filter: { sku: { in: ${jsonEncode(realSkus)} } }, pageSize: 100) { items { ...P } }',
      );
    for (var i = 0; i < ids.length; i++)
      queries.add(
        'id$i: products(search: "${ids[i]}", pageSize: 1) { items { ...P } }',
      );

    final all = <ProductModel>[];
    final seen = <String>{};
    void add(dynamic j) => (j as Map).forEach((_, v) {
      if (v is Map && v['items'] != null)
        (v['items'] as List).forEach((i) {
          final p = ProductModel.fromJson(i);
          if (!seen.contains(p.sku)) {
            seen.add(p.sku);
            all.add(p);
          }
        });
    });

    if (queries.isNotEmpty)
      (await graphQLQuery(
        'query { ${queries.join(' ')} } $frag',
        fromJson: (x) => x,
      )).fold((l) => {}, (r) => add(r));

    // Name search (Parallelized)
    final nameQueries = <String>[];
    for (var i = 0; i < names.length; i += 5) {
      final batch = names.sublist(
        i,
        i + 5 > names.length ? names.length : i + 5,
      );
      nameQueries.add(
        'query { ${batch.mapIndexed((j, t) => 'n${i + j}: products(search: "${t.replaceAll('"', '\\"')}", pageSize: 5) { items { ...P } }').join(' ')} } $frag',
      );
    }

    if (nameQueries.isNotEmpty) {
      final nameResults = await Future.wait(
        nameQueries.map((q) => graphQLQuery(q, fromJson: (x) => x)),
      );
      for (var res in nameResults) {
        res.fold((l) => {}, (r) => add(r));
      }
    }
    return Right(all);
  }

  List<ProductModel> _reconcileProds(
    Document d,
    List<HomeSectionModel> sections,
    List<ProductModel> api,
    HomeSectionType type,
  ) {
    final s = sections.firstWhereOrNull((x) => x.type == type);
    final cont = s != null ? _findCont(d, s) : null;
    if (cont == null) return [];

    final res = <ProductModel>[], seen = <String>{};
    for (var item in cont.querySelectorAll(
      '.product-item-info, .item.product',
    )) {
      final id = _getId(item),
          n = item.getText('.product-name a, .product-item-link');
      final match = api.firstWhereOrNull(
        (p) =>
            (id.isNotEmpty &&
                (p.sku == id || p.uid == id || p.id.toString() == id)) ||
            (n.isNotEmpty &&
                p.name.trim().toLowerCase() == n.trim().toLowerCase()),
      );

      final p = match != null
          ? match.copyWith(
              stockStatus: _getStock(item),
              // Preserve other API data
            )
          : _parseProdHtml(item, id, n);
      final key = p.sku.isNotEmpty ? p.sku : p.name;
      if (!seen.contains(key)) {
        seen.add(key);
        res.add(p);
      }
    }
    return res;
  }

  ProductModel _parseProdHtml(Element i, String id, String n) {
    final regularPrice = _extractPrice(
      i,
      '.old-price .price, .regular-price .price',
    );
    final finalPrice = _extractPrice(
      i,
      '.final-price .price, .special-price .price, .price',
    );

    return ProductModel(
      uid: id.isNotEmpty ? id : n,
      id: id.isNotEmpty ? id : n,
      sku: id.isNotEmpty ? id : n,
      name: n,
      stockStatus: _getStock(i),
      smallImage: SmallImage(url: i.getAttr('img', 'src')),
      priceRange: PriceRange(
        minimumPrice: Price(
          regularPrice: Money(
            value: regularPrice ?? finalPrice ?? 0.0,
            currency: 'SAR',
          ),
          finalPrice: Money(value: finalPrice ?? 0.0, currency: 'SAR'),
          discount: Discount(amountOff: 0.0, percentOff: 0.0),
        ),
      ),
      specialPrice: finalPrice,
    );
  }

  double? _extractPrice(Element i, String selector) {
    final text =
        i.querySelector(selector)?.text.replaceAll(RegExp(r'[^0-9.]'), '') ??
        '';
    return double.tryParse(text);
  }

  String _getStock(Element i) {
    final t = i.querySelector('.stock.unavailable')?.text.toLowerCase() ?? '';
    return (t.contains('out') || t.contains('غير') || t.contains('متوفر'))
        ? 'OUT_OF_STOCK'
        : 'IN_STOCK';
  }

  String _getId(Element i) {
    final v = i.getAttr('input[name="product"]', 'value');
    if (v.isNotEmpty) return v;
    final d = i.attributes['data-product-id'];
    if (d != null && d.isNotEmpty) return d;
    final a = i.getAttr('form[data-role="tocart-form"]', 'action');
    if (a.isNotEmpty) {
      final u = Uri.tryParse(a);
      if (u?.queryParameters['product'] != null)
        return u!.queryParameters['product']!;
    }
    return '';
  }

  Element? _findCont(Document d, HomeSectionModel s) {
    final id = (s.meta['identifier'] as String?)?.toLowerCase();
    final tab = d
        .querySelectorAll('.magictabs[data-ajax]')
        .firstWhereOrNull(
          (t) =>
              jsonDecode(
                t.attr('data-ajax'),
              )['identifier']?.toString().toLowerCase() ==
              id,
        );
    return tab?.parent?.parent?.querySelector('.content-products') ??
        tab?.parent?.parent ??
        tab?.parent;
  }

  // --- Categories ---
  Future<Either<HelperResponse, List<HomeCategoryModel>>>
  _fetchCategories() async => graphQLQuery(
    'query { categories { items { path path_in_store url_path uid id name image children { path path_in_store url_path uid id name image children { path path_in_store url_path uid id name image } } } } }',
    dataKey: 'categories',
    fromJson: (json) {
      final List<HomeCategoryModel> all = [];
      void add(Map<String, dynamic> c) {
        if (c['name'] != null && c['uid'] != null)
          all.add(HomeCategoryModel.fromJson(c));
        (c['children'] as List?)?.forEach(
          (ch) => add(ch as Map<String, dynamic>),
        );
      }

      (json['items'] as List?)?.forEach((i) => add(i as Map<String, dynamic>));
      return all;
    },
  );

  List<HomeCategoryModel> _reconcileCategories(
    Document doc,
    List<HomeCategoryModel> api,
  ) {
    final imgs = <String, String>{};
    for (var s in [
      '.category-item',
      '.magepow-categories .item',
      '[class*="category"]',
    ]) {
      doc.mapQuery(s, (e) {
        final n = e.getText('.category-name, .category-item-name, h3, span'),
            i = e.getAttr('img', 'src');
        if (n.isNotEmpty && i.isNotEmpty) imgs[n] = i;
      });
    }

    return doc
        .mapQuery('.shop-category .category-item, .magepow-categories .item', (
          e,
        ) {
          final n = e.getText('.category-name, .category-item-name, h3, span'),
              u = e.getAttr('a.category-url, a[href*="category"], a', 'href');
          final match = api.firstWhereOrNull(
            (c) =>
                c.name.toLowerCase().replaceAll(' ', '') ==
                n.toLowerCase().replaceAll(' ', ''),
          );
          return match != null
              ? match.copyWith(name: n, image: imgs[n] ?? match.image)
              : HomeCategoryModel(
                  uid: 'html_${n.hashCode}',
                  id: '0',
                  name: n,
                  image: imgs[n] ?? '',
                  path: u,
                  pathInStore: u,
                  urlPath: u,
                );
        })
        .where((c) => c.name.isNotEmpty)
        .toList();
  }

  // --- Banners ---
  List<PromotionalBanner> _extractBanners(
    Document d,
    List<HomeCategoryModel> cats,
  ) {
    final res = <PromotionalBanner>[],
        seen = <String>{},
        sliders = d.mapQuery('.magicslider img', (i) => i.attr('src')).toSet();
    for (var s in [
      'div.custom-banner',
      'div.banner',
      '.banner-item',
      'a.banner-link',
    ]) {
      d.mapQuery(s, (el) {
        final lnk = el.localName == 'a' ? el : el.querySelector('a'),
            img = lnk?.querySelector('img');
        if (lnk == null || img == null) return;
        final url = img.firstAttr(['src', 'data-src']),
            href = lnk.attr('href'),
            file = url.split('/').last;
        if (url.isNotEmpty &&
            href.isNotEmpty &&
            !sliders.contains(url) &&
            !seen.contains(file)) {
          seen.add(file);
          final c = _getBannerCat(href, cats);
          res.add(
            PromotionalBanner(
              imageUrl: url,
              linkUrl: href,
              title: img.attr('alt'),
              categoryId: c['id']!,
              categoryName: c['name']!,
            ),
          );
        }
      });
    }
    return res;
  }

  Map<String, String> _getBannerCat(String u, List<HomeCategoryModel> cats) {
    if (u.isEmpty) return {'id': '', 'name': ''};
    var slug = u
        .split('?')
        .first
        .split('/')
        .last
        .toLowerCase()
        .replaceAll('.html', '');
    for (var c in cats) {
      final p = c.urlPath.toLowerCase().replaceAll('.html', '').split('/').last;
      if (slug == c.id || p == slug || c.uid.toLowerCase() == slug)
        return {'id': c.id, 'name': c.name};
    }
    return {'id': slug, 'name': slug};
  }
}
