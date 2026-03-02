// utils/image_url_helper.dart
extension ImageUrlHelper on String? {
  static const _baseUrl = 'https://ar-qa.ajmal.com';

  /// Returns the best valid image URL — with fallbacks and cache-busting.
  String get bestImageUrl {
    if (this == null || this!.isEmpty) return '';
    final clean = _sanitize(this!);
    if (clean.isEmpty) return '';

    // ✅ 1. Try S3 → site + strip cache/hash
    if (clean.startsWith('https://test-media-bucket.s3')) {
      final site = _s3ToSiteDirect(clean);
      if (_isValid(site) && site != clean) return site;
    }

    // ✅ 2. Try stripping cache/<hex>/ from ANY URL (e.g. d39aae61...)
    final noCache = _removeCacheHash(clean);
    if (_isValid(noCache) && noCache != clean) return noCache;

    // ✅ 3. Try fixing relative/bare paths
    final fixed = _fixRelativeOrBare(clean);
    if (_isValid(fixed) && fixed != clean) return fixed;

    // ✅ 4. Original (last resort)
    if (_isValid(clean)) return clean;

    return '';
  }

  // ——— PRIVATE HELPERS ———

  String _sanitize(String s) => s.split('<Error>').first.trim();

  String _s3ToSiteDirect(String url) {
    return url
        .replaceFirst(
          RegExp(r'^https://test-media-bucket\.s3\.[^/]+/'),
          '$_baseUrl/media/',
        )
        .replaceAllMapped(RegExp(r'/cache/[0-9a-f]{30,40}/'), (_) => '/');
  }

  String _removeCacheHash(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAbsolutePath) return url;
    final segs = uri.pathSegments;
    final newSegs = <String>[];
    for (int i = 0; i < segs.length; i++) {
      if (segs[i] == 'cache' && i + 1 < segs.length) {
        final hash = segs[i + 1];
        if (RegExp(r'^[0-9a-f]{30,40}$').hasMatch(hash)) {
          i++; // skip hash
          continue;
        }
      }
      newSegs.add(segs[i]);
    }
    return uri.replace(pathSegments: newSegs).toString();
  }

  String _fixRelativeOrBare(String url) {
    if (url.startsWith('/')) return '$_baseUrl$url';
    if (url.contains('.') && !url.contains('/') && !url.startsWith('http')) {
      return '$_baseUrl/media/catalog/category/$url';
    }
    return url;
  }

  bool _isValid(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.isAbsolute &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
// // utils/image_url_helper.dart
// extension ImageUrlHelper on String? {
//   /// Returns the single best working image URL (with fallback logic).
//   String get bestImageUrl {
//     final candidates = allPossibleUrls;
//     return candidates.isNotEmpty ? candidates.first : '';
//   }

//   /// Returns ALL valid image URL candidates, ordered from best → fallback.
//   /// ✅ Handles: S3, cache/hash, relative paths, bare filenames, <Error>, timestamps.
//   List<String> get allPossibleUrls {
//     if (this == null || this!.isEmpty) return const [];

//     // 1️⃣ Clean: Remove <Error> and trim
//     final clean = _sanitize(this!);
//     if (clean.isEmpty) return const [];

//     // 2️⃣ Timestamp once (critical for cache-busting)
//     final ts = DateTime.now().millisecondsSinceEpoch;

//     // ✅ Candidate 1: S3 + hash → direct site (BEST)
//     final siteDirect = _s3ToSiteDirect(clean);
//     if (_isValid(siteDirect) && siteDirect != clean) {
//       return [_addTs(siteDirect, ts), ..._fallbacks(clean, ts)];
//     }

//     // ✅ Candidate 2: Clean path (remove cache/hash)
//     final withoutHash = _stripCacheHash(clean);
//     if (_isValid(withoutHash) && withoutHash != clean) {
//       return [_addTs(withoutHash, ts), ..._fallbacks(clean, ts)];
//     }

//     // ✅ Candidate 3: Fix relative / bare
//     final fixed = _fixRelativeOrBare(clean);
//     if (_isValid(fixed) && fixed != clean) {
//       return [_addTs(fixed, ts), ..._fallbacks(clean, ts)];
//     }

//     // ✅ Candidate 4: Original + timestamp (fallback)
//     if (_isValid(clean)) {
//       return [_addTs(clean, ts)];
//     }

//     return const [];
//   }

//   // ——————— PRIVATE HELPERS ——————— //

//   String _sanitize(String s) => s.split('<Error>').first.trim();

//   /// Returns fallback list (without duplicates or self)
//   List<String> _fallbacks(String original, int ts) {
//     final candidates = <String>[];

//     // 1. Clean hash
//     final clean = _stripCacheHash(original);
//     if (_isValid(clean) && clean != original) candidates.add(_addTs(clean, ts));

//     // 2. Fixed relative/filename
//     final fixed = _fixRelativeOrBare(original);
//     if (_isValid(fixed) && fixed != original && !candidates.contains(fixed)) {
//       candidates.add(_addTs(fixed, ts));
//     }

//     // 3. Original + ts
//     if (_isValid(original) && !candidates.contains(original)) {
//       candidates.add(_addTs(original, ts));
//     }

//     return candidates;
//   }

//   /// Converts S3 URL + removes hash in one efficient pass
//   String _s3ToSiteDirect(String url) {
//     if (!url.startsWith('https://test-media-bucket.s3')) return url;

//     // Step 1: Strip leading S3 bucket
//     final withoutBucket = url.replaceFirst(
//       RegExp(r'^https://-media-bucket\.s3\.[^/]+/'),
//       'https://greenup.com.sa//media/',
//     );

//     // Step 2: Strip /cache/<hex>/ anywhere in path
//     final uri = Uri.tryParse(withoutBucket);
//     if (uri == null || !uri.hasAbsolutePath) return withoutBucket;

//     final segments = uri.pathSegments;
//     final newSegments = <String>[];
//     for (int i = 0; i < segments.length; i++) {
//       if (segments[i] == 'cache' && i + 1 < segments.length) {
//         final next = segments[i + 1];
//         if (RegExp(r'^[0-9a-f]{30,40}$').hasMatch(next)) {
//           i++; // skip hash
//           continue;
//         }
//       }
//       newSegments.add(segments[i]);
//     }

//     return uri
//         .replace(
//           scheme: 'https',
//           host: 'www.group.com',
//           pathSegments: newSegments,
//         )
//         .toString();
//   }

//   /// Removes ONLY `/cache/<hex>/` — leaves rest intact
//   String _stripCacheHash(String url) {
//     final uri = Uri.tryParse(url);
//     if (uri == null || !uri.hasAbsolutePath) return url;

//     final newSegments = <String>[];
//     final segs = uri.pathSegments;
//     for (int i = 0; i < segs.length; i++) {
//       if (segs[i] == 'cache' && i + 1 < segs.length) {
//         final hash = segs[i + 1];
//         if (RegExp(r'^[0-9a-f]{30,40}$').hasMatch(hash)) {
//           i++; // skip hash
//           continue;
//         }
//       }
//       newSegments.add(segs[i]);
//     }

//     return uri.replace(pathSegments: newSegments).toString();
//   }

//   String _fixRelativeOrBare(String url) {
//     if (url.startsWith('/')) {
//       return 'https://greenup.com.sa/$url';
//     }
//     if (url.contains('.') &&
//         !url.contains('/') &&
//         !url.startsWith('http') &&
//         !url.startsWith('https')) {
//       // Bare filename → assume category image
//       return 'https://greenup.com.sa//media/catalog/category/$url';
//     }
//     return url;
//   }

//   bool _isValid(String url) {
//     if (url.isEmpty) return false;
//     final uri = Uri.tryParse(url);
//     return uri != null &&
//         uri.isAbsolute &&
//         (uri.scheme == 'http' || uri.scheme == 'https');
//   }

//   String _addTs(String url, int ts) {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return url;
//     final q = uri.query;
//     final newQ = q.isEmpty ? '_t=$ts' : '$q&_t=$ts';
//     return uri.replace(query: newQ).toString();
//   }
// }
// // utils/image_url_helper.dart
// extension ImageUrlHelper on String? {
//   /// Returns the best possible valid image URL after sanitization & conversion.
//   String get bestImageUrl {
//     final candidates = _generateCandidateUrls();
//     return candidates.isNotEmpty ? candidates.first : '';
//   }

//   /// Returns all valid image URL candidates (best → fallback).
//   List<String> get allPossibleUrls => _generateCandidateUrls();

//   /// Generates candidate URLs in order of preference.
//   List<String> _generateCandidateUrls() {
//     final raw = this;
//     if (raw == null || raw.isEmpty) return const [];

//     // 1️⃣ Clean once: remove <Error> artifacts
//     final clean = _cleanError(raw);
//     if (clean.isEmpty) return const [];

//     // 2️⃣ Timestamp once (for performance & cache busting)
//     final ts = DateTime.now().millisecondsSinceEpoch;

//     final candidates = <String>[];

//     // 🔹 Candidate 1: Remove cache/<hash>/ (e.g. /cache/9320ae4c.../ → /)
//     final withoutCache = _removeCacheHash(clean);
//     if (_isValidUrl(withoutCache) && withoutCache != clean) {
//       candidates.add(_addTimestamp(withoutCache, ts));
//     }

//     // 🔹 Candidate 2: Original + timestamp (if valid)
//     if (_isValidUrl(clean)) {
//       candidates.add(_addTimestamp(clean, ts));
//     }

//     // 🔹 Candidate 3: S3 → Site conversion
//     if (clean.startsWith('https://test-media-bucket.s3')) {
//       final siteUrl = _convertS3ToSite(clean);
//       if (_isValidUrl(siteUrl) && siteUrl != clean) {
//         candidates.add(_addTimestamp(siteUrl, ts));
//       }
//     }

//     // 🔹 Candidate 4: Fix relative paths & bare filenames
//     if (!_isAbsoluteUrl(clean)) {
//       final fixed = _fixRelativeOrBare(clean);
//       if (_isValidUrl(fixed) && fixed != clean) {
//         candidates.add(_addTimestamp(fixed, ts));
//       }
//     }

//     // 🔹 Deduplicate (preserve order, fail-safe)
//     return candidates.fold<List<String>>(
//       <String>[],
//       (acc, url) => acc.contains(url) ? acc : [...acc, url],
//     );
//   }

//   // ✅ Pure helpers — no side effects, no exceptions

//   String _cleanError(String s) => s.split('<Error>').first.trim();

//   bool _isAbsoluteUrl(String s) {
//     final uri = Uri.tryParse(s);
//     return uri != null && uri.isAbsolute;
//   }

//   bool _isValidUrl(String s) {
//     if (s.isEmpty) return false;
//     final uri = Uri.tryParse(s);
//     if (uri == null) return false;
//     return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
//   }

//   String _addTimestamp(String url, int ts) {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return url;
//     final newQuery = uri.query.isEmpty ? '_t=$ts' : '${uri.query}&_t=$ts';
//     return uri.replace(query: newQuery).toString();
//   }

//   /// Removes `/cache/{32+ hex chars}/` from path (e.g. /cache/9320ae4c2b4f574c44643da511da7547/)
//   String _removeCacheHash(String url) {
//     final uri = Uri.tryParse(url);
//     if (uri == null || !uri.hasAbsolutePath) return url;

//     final segments = uri.pathSegments;
//     final newSegments = <String>[];

//     for (int i = 0; i < segments.length; i++) {
//       if (segments[i] == 'cache' && i + 1 < segments.length) {
//         // Check next segment: must be long hex (30–40 chars)
//         final hash = segments[i + 1];
//         if (RegExp(r'^[0-9a-f]{30,40}$').hasMatch(hash)) {
//           i++; // skip cache + hash
//           continue;
//         }
//       }
//       newSegments.add(segments[i]);
//     }

//     return uri.replace(pathSegments: newSegments).toString();
//   }

//   String _convertS3ToSite(String s3Url) {
//     // Example:
//     // s3: https://-media-bucket.s3.eu-west-1.amazonaws.com/catalog/product/...
//     // → site: https://greenup.com.sa//media/catalog/product/...
//     return s3Url.replaceFirst(
//       RegExp(r'^https://-media-bucket\.s3\.[^/]+/'),
//       'https://greenup.com.sa//media/',
//     );
//   }

//   String _fixRelativeOrBare(String url) {
//     if (url.startsWith('/')) {
//       return 'https://greenup.com.sa/$url';
//     }

//     // Assume it's a bare filename like "Collective_600X600_1.png"
//     if (url.contains('.') && !url.contains('/') && !url.startsWith('http')) {
//       return 'https://greenup.com.sa//media/catalog/category/$url';
//     }

//     return url;
//   }
// }
// // utils/image_url_helper.dart

// extension ImageUrlHelper on String? {
//   static const _baseUrl = 'https://greenup.com.sa/';

//   List<String> get allPossibleUrls {
//     if (this == null || this!.isEmpty) return [];

//     final clean = _cleanUrl(this!);
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final urls = <String>[];

//     // ✅ 1. Try clean direct (without cache hash like 9320ae4c...)
//     final direct = _removeCacheHash(clean);
//     if (direct != clean && _isValidUrl(direct)) {
//       urls.add(_addTimestamp(direct, timestamp));
//     }

//     // ✅ 2. Original + timestamp
//     if (_isValidUrl(clean)) {
//       urls.add(_addTimestamp(clean, timestamp));
//     }

//     // ✅ 3. Try S3 → Site conversion
//     if (clean.contains('-media-bucket.s3')) {
//       final siteUrl = _convertS3ToSiteUrl(clean);
//       if (_isValidUrl(siteUrl) && siteUrl != clean) {
//         urls.add(_addTimestamp(siteUrl, timestamp));
//       }
//     }

//     // ✅ 4. Try fixing relative paths
//     final fixed = _fixRelativePath(clean);
//     if (fixed != clean && _isValidUrl(fixed)) {
//       urls.add(_addTimestamp(fixed, timestamp));
//     }

//     // ✅ Remove duplicates while preserving order
//     return urls.toSet().toList();
//   }

//   String get bestImageUrl =>
//       allPossibleUrls.isNotEmpty ? allPossibleUrls.first : '';

//   String _cleanUrl(String raw) => raw.split('<Error>').first.trim();

//   /// إزالة `cache/<any_hash_32>` من المسار (مثل 9320ae4c2b4f574c44643da511da7547)
//   String _removeCacheHash(String url) {
//     final uri = Uri.tryParse(url);
//     if (uri == null || !uri.hasAbsolutePath) return url;

//     final segments = uri.pathSegments;
//     final newSegments = <String>[];

//     for (int i = 0; i < segments.length; i++) {
//       if (segments[i] == 'cache' && i + 1 < segments.length) {
//         final hash = segments[i + 1];
//         // hash غالبًا 32 حرف هكس (مثل md5)، أو أطول قليلًا
//         if (RegExp(r'^[0-9a-f]{30,36}$').hasMatch(hash)) {
//           i++; // skip hash too
//           continue;
//         }
//       }
//       newSegments.add(segments[i]);
//     }

//     return uri.replace(pathSegments: newSegments).toString();
//   }

//   String _convertS3ToSiteUrl(String s3Url) {
//     // مثال:
//     // s3: https://-media-bucket.s3.eu-west-1.amazonaws.com/catalog/product/...
//     // → site: https://greenup.com.sa//media/catalog/product/...
//     return s3Url.replaceFirst(
//       RegExp(r'https://-media-bucket\.s3\.[^/]+/'),
//       '$_baseUrl/media/',
//     );
//   }

//   /// تصحيح المسارات النسبية أو أسماء الملفات فقط
//   /// مثال:
//   ///  - "/media/..." → "https://.../media/..."
//   ///  - "filename.png" → "https://.../media/catalog/category/filename.png"
//   String _fixRelativePath(String url) {
//     if (url.startsWith('http')) return url;

//     // حالة 1: مسار نسبي (يبدأ بـ /)
//     if (url.startsWith('/')) {
//       return '$_baseUrl$url';
//     }

//     // حالة 2: اسم ملف فقط (مثل "Collective_600X600_1.png")
//     // نفترض أنه صورة قسم (category)، لذا نضعه في مسار category
//     if (url.contains('.') && !url.contains('/')) {
//       return '$_baseUrl/media/catalog/category/$url';
//     }

//     return url;
//   }

//   String _addTimestamp(String url, int ts) {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return url;

//     final newQuery = uri.query.isEmpty ? '_t=$ts' : '${uri.query}&_t=$ts';
//     return uri.replace(query: newQuery).toString();
//   }

//   bool _isValidUrl(String url) {
//     if (url.isEmpty || url.contains('<Error>')) return false;
//     try {
//       final uri = Uri.parse(url);
//       return uri.isAbsolute && ['http', 'https'].contains(uri.scheme);
//     } catch (_) {
//       return false;
//     }
//   }
// }
