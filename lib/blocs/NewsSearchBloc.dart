import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchState.dart';
import 'package:news_app_bloc/models/NewsModel.dart';
import 'package:news_app_bloc/utils/Constants.dart';

import '../resources/NewsRepository.dart';

class NewsSearchBloc extends Cubit<NewsSearchState>{

  int _currentpage=0;
  int _totalPageSize=0;
  String query="";
  List<NewsItem> newsList=[];

  NewsRepository repository=NewsRepository();

  NewsSearchBloc(NewsSearchState initialState) : super(initialState);



  searchNews(String query) async{
    if(query.isNotEmpty) {
      this.query = query;
      _currentpage = 1;
      try {
        emit(NewsLoadingState());
        final result=await repository.searchNews(query, _currentpage);
        newsList=result.articles;
        _totalPageSize = result.totalResults;
        emit(NewsFetchedState(newsList: newsList));
      } on SocketException {
        emit(NewsErrorState(error: Constants.NOINTERNET));
      } on HttpException {
        emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
      } on FormatException {
        emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
      }
    }
  }

  onPagination() async{
    if(query.isNotEmpty&&_totalPageSize!=newsList.length) {
      _currentpage++;
      try {
        final result=await repository.searchNews(query, _currentpage);
        newsList.addAll(result.articles);
        _totalPageSize = result.totalResults;
        emit(NewsFetchedState(newsList: newsList));
      } on SocketException {
        emit(NewsErrorState(error: Constants.NOINTERNET));
      } on HttpException {
        emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
      } on FormatException {
        emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
      }
    }
  }


}