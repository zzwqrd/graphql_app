import '../../../../core/utils/image_url_helper.dart';

class HomeCategoryModel {
  final String uid;
  final String id;
  final String name;
  final String image;
  final String path;
  final String pathInStore;
  final String urlPath;

  HomeCategoryModel({
    required this.uid,
    required this.id,
    required this.name,
    required this.image,
    required this.path,
    required this.pathInStore,
    required this.urlPath,
  });

  HomeCategoryModel copyWith({
    String? uid,
    String? id,
    String? name,
    String? image,
    String? path,
    String? pathInStore,
    String? urlPath,
  }) {
    return HomeCategoryModel(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      path: path ?? this.path,
      pathInStore: pathInStore ?? this.pathInStore,
      urlPath: urlPath ?? this.urlPath,
    );
  }

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      uid: json['uid'] as String? ?? '',
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      path: json['path'] as String? ?? '',
      pathInStore: json['path_in_store'] as String? ?? '',
      urlPath: json['url_path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'name': name,
      'image': image,
      'path': path,
      'path_in_store': pathInStore,
      'url_path': urlPath,
    };
  }

  String get displayImageUrl => image.bestImageUrl;

  String get localizedName => name;
}
