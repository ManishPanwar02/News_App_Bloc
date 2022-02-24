import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsApiBloc.dart';
import 'package:news_app_bloc/blocs/NewsCategoryBloc.dart';
import 'package:news_app_bloc/blocs/NewsCountryBloc.dart';
import 'package:news_app_bloc/blocs/NewsSearchBloc.dart';
import 'package:news_app_bloc/blocs/NewsSearchPaginationBloc.dart';
import 'package:news_app_bloc/blocs/NewsSourcesBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCategoryState.dart';
import 'package:news_app_bloc/blocs/states/NewsCountryState.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchPaginationState.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchState.dart';
import 'package:news_app_bloc/blocs/states/NewsSourcesState.dart';
import 'package:news_app_bloc/blocs/states/NewsState.dart';
import 'package:news_app_bloc/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final newsApiBloc=NewsApiBloc(NewsState());
  final newsCategoryBloc=NewsCategoryBloc(NewsCategoryState());
  final newsCountryBloc=NewsCountryBloc(NewsCountryState());
  final newsSourcesBloc=NewsSourcesBloc(NewsSourcesState());
  final newsSearchBloc=NewsSearchBloc(NewsSearchState());
  final newsSearchPaginationBloc=NewsSearchPaginationBloc(NewsSearchPaginationState());


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context)=>newsApiBloc),
      BlocProvider(create: (context)=>newsCategoryBloc),
      BlocProvider(create: (context)=>newsCountryBloc),
      BlocProvider(create: (context)=>newsSourcesBloc),
      BlocProvider(create: (context)=>newsSearchBloc),
      BlocProvider(create: (context)=>newsSearchPaginationBloc)
    ],child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:Color(0xff0c54be) ,
      ),
      home:HomeScreen(),
    ));
  }
}

