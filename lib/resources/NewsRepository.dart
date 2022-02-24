import 'package:news_app_bloc/resources/NewsApiProvider.dart';

import '../models/NewsModel.dart';

class NewsRepository{
  final newsApi=NewsApiProvider();

  Future<NewsModel> getTopHeadlines(String countryCode,String sortBy,int page){
    return newsApi.getTopHeadlines(countryCode, sortBy, page);
  }

  Future<NewsModel> getSourcesHeadlines(String sortBy,String sources,int page){
    return newsApi.filterThroughSources(sortBy, sources, page);
  }

  Future<NewsModel> searchNews(String query,int page){
   return newsApi.searchNews(query,page);
  }

}