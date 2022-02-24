import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsApiBloc.dart';
import 'package:news_app_bloc/blocs/NewsCategoryBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsCategoryState.dart';

class TopHeadLinesWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            "Top Headlines",
            style: TextStyle(fontFamily: 'Lato'),
          ),
          SortByWidget()
        ]));
  }
}

class SortByWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsCategoryBloc = BlocProvider.of<NewsCategoryBloc>(context);
    final newsApiBloc = BlocProvider.of<NewsApiBloc>(context);
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                  onTap: () {
                    newsCategoryBloc.onCategoryChange("popularity");
                    newsApiBloc.changeSortBy("popularity");
                  },
                  child: const Text("Popularity")),
              PopupMenuItem(
                  onTap: () {
                    newsCategoryBloc.onCategoryChange("publishedAt");
                    newsApiBloc.changeSortBy("publishedAt");
                  },
                  child: const Text("Published At"))

            ],
        child: Row(children: [
          const Text(
            "Sort",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 4),
          BlocBuilder<NewsCategoryBloc, NewsCategoryState>(
              builder: (context, state) {
            String cat = "publishedAt";
            if (state is NewsCategoryChangedState) {
              cat = state.cat;
            }
            return Row(
              children: [
                Text(cat),
                const ImageIcon(
                    AssetImage("assets/image/icons8-sort-down-48.png"))
              ],
            );
          })
        ]));
  }
}
