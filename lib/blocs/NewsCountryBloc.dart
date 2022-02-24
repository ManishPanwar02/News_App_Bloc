import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCountryState.dart';

class NewsCountryBloc extends Cubit<NewsCountryState>{
  NewsCountryBloc(NewsCountryState initialState) : super(initialState);

  String country="India";
  onCountryChange(String country){
    this.country=country;
    emit(NewsCountrySelectedState(country: country));
  }

  onCountryChangeApplied(String country){
    this.country=country;
    emit(NewsCountryChangedState(country: country));
  }

  
}