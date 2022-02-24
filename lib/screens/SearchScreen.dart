import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchPaginationState.dart';
import 'package:news_app_bloc/blocs/states/NewsSearchState.dart';

import '../blocs/NewsSearchBloc.dart';
import '../blocs/NewsSearchPaginationBloc.dart';
import '../models/NewsModel.dart';
import 'NewsDetailScreen.dart';

class SearchPage extends StatelessWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final newsSearchBloc = BlocProvider.of<NewsSearchBloc>(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        newsSearchBloc.onPagination();
      }
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff0c54be),
          title: const Text("Search"),
        ),
        body: Container(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                decoration: const BoxDecoration(
                    color: Color(0XFFCED3DC),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              // _searchNews(value, false);
                              newsSearchBloc.searchNews(value);
                            },
                            decoration: const InputDecoration(
                                hintText: "Search here",
                                border: InputBorder.none),
                          ),
                        ),
                        const Icon(CupertinoIcons.search)
                      ]),
                )),
          ),
          BlocBuilder<NewsSearchBloc, NewsSearchState>(
              builder: (context, state) {
            if (state is NewsFetchedState) {
              return ListItem(
                  newsList: state.newsList, scrollController: scrollController);
            } else if (state is NewsLoadingState) {
              return const Expanded(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            } else if (state is NewsErrorState) {
              final error = state.error;
              return Container(
                child: Center(
                  child: Text(error),
                ),
              );
            }
            return Text("");
          }),
          BlocBuilder<NewsSearchPaginationBloc, NewsSearchPaginationState>(
              builder: (context, state) {
            double height = 0.0;
            if (state is NewsSearchPaginationLoadingState) {
              height = 30.0;
            } else {
              height = 0.0;
            }
            return SizedBox(
              height: height,
              child: const Center(child: CircularProgressIndicator()),
            );
          })
        ])));
  }
}

class ListItem extends StatelessWidget {
  final List<NewsItem> newsList;
  final ScrollController scrollController;

  ListItem({required this.newsList, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: newsList.length,
          itemBuilder: (context, position) {
            final ele = newsList[position];
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailScreen(newsItem: ele)));
                },
                child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Card(
                            elevation: 2,
                            child: Container(
                              height: 140,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${ele.source?.name}",
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.italic)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text("${ele.title}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "${convertToAgo(DateTime.parse("${ele.publishedAt}"))}",
                                                  style: const TextStyle(
                                                      fontFamily: 'Lato'))
                                            ],
                                          ))),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        height: 140,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: (ele.urlToImage != null)
                                                  ? Image.network(
                                                      "${ele.urlToImage}",
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      "assets/image/icons8-news-100.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                            )),
                                      ))
                                ],
                              ),
                            )))));
          }),
    );
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
