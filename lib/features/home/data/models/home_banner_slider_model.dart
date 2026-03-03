class BannersSliderOutputHome {
  final List<SliderData> slider;
  final List<BannerData> banners;

  BannersSliderOutputHome({required this.slider, required this.banners});

  factory BannersSliderOutputHome.fromJson(Map<String, dynamic> json) {
    return BannersSliderOutputHome(
      slider:
          (json['slider'] as List?)
              ?.map((e) => SliderData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      banners:
          (json['banners'] as List?)
              ?.map((e) => BannerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SliderData {
  final int? sliderId;
  final String? name;
  final int? status;
  final String? location;
  final String? effect;
  final String? autoplayTimeout;
  final String? fromDate;
  final String? toDate;

  SliderData({
    this.sliderId,
    this.name,
    this.status,
    this.location,
    this.effect,
    this.autoplayTimeout,
    this.fromDate,
    this.toDate,
  });

  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      sliderId: json['slider_id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as int?,
      location: json['location'] as String?,
      effect: json['effect'] as String?,
      autoplayTimeout: json['autoplayTimeout']?.toString(), // Handle string/int
      fromDate: json['from_date'] as String?,
      toDate: json['to_date'] as String?,
    );
  }
}

class BannerData {
  final int? bannerId;
  final String? name;
  final bool? status;
  final String? image;
  final String? urlBanner;
  final String? bannerSubtitle;
  final String? title;

  BannerData({
    this.bannerId,
    this.name,
    this.status,
    this.image,
    this.urlBanner,
    this.bannerSubtitle,
    this.title,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      bannerId: json['banner_id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as bool?,
      image: json['image'] as String?,
      urlBanner: json['url_banner'] as String?,
      bannerSubtitle: json['banner_subtitle'] as String?,
      title: json['title'] as String?,
    );
  }
}
