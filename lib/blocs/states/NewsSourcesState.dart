class NewsSourcesState{

}

class NewsSourcesAddedState extends NewsSourcesState{
  final List<String>sourcesList;

  NewsSourcesAddedState({required this.sourcesList});

}

class NewsSourcesRemovedState extends NewsSourcesState{
  final List<String>sourcesList;

  NewsSourcesRemovedState({required this.sourcesList});

}