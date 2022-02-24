import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchPaginationState.dart';

class NewsSearchPaginationBloc extends Cubit<NewsSearchPaginationState>{

  NewsSearchPaginationBloc(NewsSearchPaginationState initialState) : super(initialState);


  onPaginationLoading(){
    emit(NewsSearchPaginationLoadingState());
  }
  onPaginationLoaded(){
    emit(NewsSearchPaginationLoadedState());
  }
}