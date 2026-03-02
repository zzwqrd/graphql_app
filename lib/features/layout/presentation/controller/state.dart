class LayoutState {
  final int currentIndex;
  final String title;

  LayoutState({this.currentIndex = 0, this.title = ''});

  LayoutState copyWith({int? currentIndex, String? title}) {
    return LayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      title: title ?? this.title,
    );
  }
}
