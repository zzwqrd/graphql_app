class CmsBlocksOutput {
  final List<CmsBlockData> items;

  CmsBlocksOutput({required this.items});

  factory CmsBlocksOutput.fromJson(Map<String, dynamic> json) {
    return CmsBlocksOutput(
      items: json['items'] != null
          ? List<CmsBlockData>.from(
              (json['items'] as List).map(
                (x) => CmsBlockData.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }
}

class CmsBlockData {
  final String? identifier;
  final String? content;
  final String? title;

  CmsBlockData({this.identifier, this.content, this.title});

  factory CmsBlockData.fromJson(Map<String, dynamic> json) {
    return CmsBlockData(
      identifier: json['identifier'] as String?,
      content: json['content'] as String?,
      title: json['title'] as String?,
    );
  }
}
