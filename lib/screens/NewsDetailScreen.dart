import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/NewsModel.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  NewsDetailScreen({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff0c54be)),
      body: NewsDetailBody(newsItem: newsItem),
    );
  }
}

class NewsDetailBody extends StatelessWidget {
  final NewsItem newsItem;

  NewsDetailBody({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    String details = "";
    if (newsItem.content != null) {
      details = newsItem.content!;
    } else if (newsItem.description != null) {
      details = newsItem.description!;
    } else {
      details = "No details Found";
    }
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        Container(
            width: double.infinity,
            height: 250,
            child: (newsItem.urlToImage != null)
                ? Image.network("${newsItem.urlToImage}", fit: BoxFit.cover)
                : Image.asset(
                    "assets/image/icons8-news-100.png",
                    fit: BoxFit.cover,
                  )),
        Positioned.fill(
            child: Padding(
          padding: const EdgeInsets.all(0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                child: Card(
                    color: Colors.transparent,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("${newsItem.title}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600)))),
              )),
        )),
      ]),
      Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 10),
            Text(
              "${newsItem.source?.name}",
              style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
            ),
            Text(convertToAgo(DateTime.parse("${newsItem.publishedAt}"))),
            const SizedBox(height: 10),
            Text(
              details,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () async {
                  if (await canLaunch("${newsItem.url}")) {
                    await launch("${newsItem.url}", forceSafariVC: false);
                  }
                },
                child: Container(
                  width: 120,
                  height: 30,
                  child: 
                  Row(
                    children: [
                      const Text("See Full Story",style: TextStyle(
                        color: Color(0xff0c54be),
                        fontFamily: "Lato"
                      ),),
                      const SizedBox(
                          width: 4),
                      SizedBox(
                        height: 15,
                          child: Image.asset("assets/image/icons8-right-arrow-64.png",color: Color(0xff0c54be),))
                    ],
                  ),
                ))
          ]))
    ]));
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
