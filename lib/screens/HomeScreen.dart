import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_bloc/blocs/NewsApiBloc.dart';
import 'package:news_app_bloc/blocs/states/NewsState.dart';
import 'package:news_app_bloc/models/NewsModel.dart';
import 'package:news_app_bloc/screens/CountryFilter.dart';
import 'package:news_app_bloc/screens/NewsSourcesBottomSheet.dart';
import 'package:news_app_bloc/screens/TopHeadlines.dart';
import 'NewsDetailScreen.dart';
import 'SearchScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("NewsApp"),
          backgroundColor: const Color(0xff0c54be),
          actions: [CountryFilter()],
        ),
        floatingActionButton: BlocBuilder<NewsApiBloc, NewsState>(
          builder: (context, state) {
            bool hide = false;
            if (state is NewsLoadingState) {
              hide = true;
            } else {
              hide = false;
            }
            return SizedBox(
              height: hide ? 0 : 56,
              child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return NewsSourcesBottomSheet();
                        });
                  },
                  child: const ImageIcon(
                      AssetImage("assets/image/filter_icon.png")),
                  backgroundColor: const Color(0xff0c54be)),
            );
          },
        ),
        body: Column(
          children: [
            BlocBuilder<NewsApiBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoadingState) {
                  return const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                } else if (state is NewsFetchedState) {
                  return ListItem(
                      newsList: state.newsList, isPagination: false);
                } else if (state is NewsPaginationLoadingState) {
                  return ListItem(newsList: state.newsList, isPagination: true);
                } else if (state is NewsPaginationCompleteState) {
                  return ListItem(
                      newsList: state.newsList, isPagination: false);
                } else {
                  return Text("error");
                }
              },
            )
          ],
        ));
  }
}

class ListItem extends StatelessWidget {
  final scrollController = ScrollController();
  final List<NewsItem> newsList;
  final bool isPagination;

  ListItem({required this.newsList, required this.isPagination});

  @override
  Widget build(BuildContext context) {
    final newsApiBloc = BlocProvider.of<NewsApiBloc>(context);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        newsApiBloc.onPagination();
      }
    });
    return Expanded(
      child: Column(
        children: [
          SearchBox(),
          TopHeadLinesWidgets(),
          Expanded(
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
                                child: SizedBox(
                                  height: 140,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${ele.source?.name}",
                                                      style: const TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle: FontStyle
                                                              .italic)),
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
                                                      convertToAgo(DateTime.parse(
                                                          "${ele.publishedAt}")),
                                                      style: const TextStyle(
                                                          fontFamily: 'Lato'))
                                                ],
                                              ))),
                                      Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            height: 140,
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      "${ele.urlToImage}",
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (context, exc, st) {
                                                        return const ImageIcon(
                                                            AssetImage(
                                                                "assets/image/icons8-news-100.png"));
                                                      },
                                                    ))),
                                          ))
                                    ],
                                  ),
                                )))),
                  );
                }),
          ),
          SizedBox(
            height: isPagination ? 30 : 0,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
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

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          },
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
                    children: const [
                      Text("Search Here"),
                      Icon(CupertinoIcons.search)
                    ]),
              )),
        ));
  }
}
