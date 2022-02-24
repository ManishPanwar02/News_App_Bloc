import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsState.dart';
import 'package:news_app_bloc/models/NewsModel.dart';
import 'package:news_app_bloc/resources/NewsRepository.dart';
import 'package:news_app_bloc/utils/Constants.dart';

class NewsApiBloc extends Cubit<NewsState> {
  final _repository = NewsRepository();
  String _countryCode = "in";
  String _sortBy = "publishedAt";
  int _currentPage = 1;
  int _totalSize = 0;
  List<NewsItem> _newsList = [];
  String _sourceStr = "";
  Map<String, String> sourcesMap = {
    "BBC News": "bbc-news",
    "ABC News": "abc-news",
    "Al Jazeera English": "al-jazeera-english",
    "Associated Press": "associated-press",
    "Bloomberg": "bloomberg"
  };

  NewsApiBloc(NewsState initialState) : super(initialState) {
    onNewsFetch();
  }

  onNewsFetch() async {
    try {
      emit(NewsLoadingState());
      _currentPage = 1;
      final result = await _repository.getTopHeadlines(
          _countryCode, _sortBy, _currentPage);
      _newsList = result.articles;
      _totalSize = result.totalResults;
      emit(NewsFetchedState(sortBy: _sortBy, newsList: _newsList));
    } on SocketException {
      emit(NewsErrorState(error: Constants.NOINTERNET));
    } on HttpException {
      emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
    } on FormatException {
      emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
    }
  }

  changeSortBy(String filter) {
    _sortBy = filter;
    onNewsFetchThroughCat();
  }

  onNewsFetchThroughCat() {
    if (_sortBy == "popularity" && _sourceStr.isNotEmpty) {
      fetchThroughSources();
    }
  }

  changeSourcesString(List<String> list) {
    if (list.isNotEmpty) {
      if (list.length == 1) {
        _sourceStr = sourcesMap[list[0]]!;
      } else {
        _sourceStr = list.map((e) => sourcesMap[e]).toList().join(",");
      }
      fetchThroughSources();
    }
  }

  fetchThroughSources() async {
    try {
      emit(NewsLoadingState());
      _currentPage = 1;
      final result = await _repository.getSourcesHeadlines(
          _sortBy, _sourceStr, _currentPage);
      _newsList = result.articles;
      _totalSize = result.totalResults;
      emit(NewsFetchedState(sortBy: _sortBy, newsList: _newsList));
    } on SocketException {
      emit(NewsErrorState(error: Constants.NOINTERNET));
    } on HttpException {
      emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
    } on FormatException {
      emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
    }
  }

  onPagination() async {
    // means we have to paginate through sourceApi
    if (_sourceStr.isNotEmpty) {
      if (_totalSize == _newsList.length) {
        emit(NewsPaginationCompleteState(newsList: _newsList));
      } else {
        _paginateThroughSources();
      }
    }
    // we have to paginate through normal api
    else {
      if (_totalSize == _newsList.length) {
        emit(NewsPaginationCompleteState(newsList: _newsList));
      } else {
        _paginateTopHeadlines();
      }
    }
  }

  _paginateThroughSources() async {
    try {
      _currentPage++;
      emit(NewsPaginationLoadingState(newsList: _newsList));
      final result = await _repository.getSourcesHeadlines(
          _sortBy, _sourceStr, _currentPage);
      _newsList.addAll(result.articles);
      _totalSize = result.totalResults;
      emit(NewsPaginationCompleteState(newsList: _newsList));
    } on SocketException {
      emit(NewsErrorState(error: Constants.NOINTERNET));
    } on HttpException {
      emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
    } on FormatException {
      emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
    }
  }

  _paginateTopHeadlines() async {
    try {
      _currentPage++;
      emit(NewsPaginationLoadingState(newsList: _newsList));
      final result = await _repository.getTopHeadlines(
          _countryCode, _sortBy, _currentPage);
      _newsList.addAll(result.articles);
      _totalSize = result.totalResults;
      emit(NewsPaginationCompleteState(newsList: _newsList));
    } on SocketException {
      emit(NewsErrorState(error: Constants.NOINTERNET));
    } on HttpException {
      emit(NewsErrorState(error: Constants.HTTPEXCEPTION));
    } on FormatException {
      emit(NewsErrorState(error: Constants.OTHEREXCEPTION));
    }
  }
  changeCountryCode(String code){
    _countryCode=code;
    onNewsFetch();
  }
}
