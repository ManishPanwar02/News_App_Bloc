import 'package:news_app_bloc/models/NewsModel.dart';

class NewsState{

}
class NewsInitialState extends NewsState{

}

class NewsLoadingState extends NewsState{

}
class NewsFetchedState extends NewsState{
  final List<NewsItem> newsList;
  final String sortBy;
  NewsFetchedState({required this.newsList,required this.sortBy});


}
class NewsLoadingCompleteState extends NewsState{
}

class NewsErrorState extends NewsState{
  final String error;
  NewsErrorState({required this.error});

}

class NewsPaginationLoadingState extends NewsState{
  final List<NewsItem> newsList;
  NewsPaginationLoadingState({required this.newsList});
}

class NewsPaginationCompleteState extends NewsState{
  final List<NewsItem> newsList;
  NewsPaginationCompleteState({required this.newsList});
}



class NewsFilterChangeState extends NewsState{
  final String filter;
  NewsFilterChangeState({required this.filter});
}