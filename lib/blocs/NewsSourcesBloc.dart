import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsSourcesState.dart';

class NewsSourcesBloc extends Cubit<NewsSourcesState>{
  NewsSourcesBloc(NewsSourcesState initialState) : super(initialState);

   List<String>sources=[];


   onSourceClick(String source){
     if(sources.contains(source)){
       sources.remove(source);
       emit(NewsSourcesRemovedState(sourcesList: sources));
     }
     else{
       sources.add(source);
       emit(NewsSourcesAddedState(sourcesList: sources));
     }
   }

   getAllSources(){
     emit(NewsSourcesAddedState(sourcesList: sources));
   }

}