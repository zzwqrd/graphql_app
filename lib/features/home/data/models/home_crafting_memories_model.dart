class CraftingMemoriesOutput {
  final CraftingMemoriesData? data;

  CraftingMemoriesOutput({this.data});

  factory CraftingMemoriesOutput.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null && (json['items'] as List).isNotEmpty) {
      return CraftingMemoriesOutput(
        data: CraftingMemoriesData.fromJson(
          (json['items'] as List).first as Map<String, dynamic>,
        ),
      );
    }
    return CraftingMemoriesOutput(data: null);
  }
}

class CraftingMemoriesData {
  final String? identifier;
  final String? content;
  final String? title;

  CraftingMemoriesData({this.identifier, this.content, this.title});

  factory CraftingMemoriesData.fromJson(Map<String, dynamic> json) {
    return CraftingMemoriesData(
      identifier: json['identifier'] as String?,
      content: json['content'] as String?,
      title: json['title'] as String?,
    );
  }
}
