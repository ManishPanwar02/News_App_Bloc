import '../../models/NewsModel.dart';

class NewsSearchState{

}

class NewsLoadingState extends NewsSearchState{

}

class NewsFetchedState extends NewsSearchState{
  final List<NewsItem> newsList;

  NewsFetchedState({required this.newsList});




}


class NewsErrorState extends NewsSearchState{
  final String error;
  NewsErrorState({required this.error});
}