import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsApiBloc.dart';
import 'package:news_app_bloc/blocs/NewsSourcesBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsSourcesState.dart';

class NewsSourcesBottomSheet extends StatelessWidget {
  final sourcesList = [
    "BBC News",
    "ABC News",
    "Al Jazeera English",
    "Associated Press",
    "Bloomberg",
    "Buzzfeed"
  ];
  List<String> selectedSources=[];

  @override
  Widget build(BuildContext context) {
    final newsApiBloc=BlocProvider.of<NewsApiBloc>(context);
    final newsSourceBloc=BlocProvider.of<NewsSourcesBloc>(context);
    // newsBloc.onSourceInitialisation();
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 4,
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  color: Color(0xFFd9d9d9),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Text(
                "Filter By Sources",
                style: TextStyle(fontFamily: 'Lato', fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Container(
                height: 2,
                color: Color(0xFFd9d9d9),
              ),
            ),
            BlocBuilder<NewsSourcesBloc,NewsSourcesState>(builder: (context,state){
              if(state is NewsSourcesAddedState) {
                selectedSources=state.sourcesList;
              }
              else if(state is NewsSourcesRemovedState){
                selectedSources=state.sourcesList;
              }
              return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: sourcesList.length,
                      itemBuilder: (context, pos) {
                        return NewsSourcesItem(
                            source: sourcesList[pos],
                            selectedNewsSources: selectedSources);
                      }));
            }),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  newsApiBloc.changeSourcesString(selectedSources);
                  Navigator.pop(context);
                },
                child: Text(
                  "Apply",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsSourcesItem extends StatelessWidget {
  final String source;
  List<String> selectedNewsSources;

  NewsSourcesItem({required this.source, required this.selectedNewsSources});
  
  @override
  Widget build(BuildContext context) {
    final newsSourcesBloc=BlocProvider.of<NewsSourcesBloc>(context);
    return ListTile(
      leading: Text(source),
      trailing: InkWell(
        onTap: () {
          print("oNCLIC");
        },
        child: Checkbox(
          onChanged: (bool? value){
              newsSourcesBloc.onSourceClick(source);
          }, value: selectedNewsSources.contains(source)
          ,
        ),
      ),
    );
  }
}
