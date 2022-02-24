import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCategoryState.dart';

class NewsCategoryBloc extends Cubit<NewsCategoryState>{


  NewsCategoryBloc(NewsCategoryState initialState) : super(initialState);

  onCategoryChange(String cat){
    emit(NewsCategoryChangedState(cat: cat));
  }


}