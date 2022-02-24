import 'dart:convert';

import '../models/NewsModel.dart';
import 'package:http/http.dart' as http;
class NewsApiProvider{

  final _apiKey = "d3dbd2b79ae44b17870bb7bff405dc47";

  Future<NewsModel> getTopHeadlines(
      String countryCode, String sortBy, int page) async {
    final url =
        "https://newsapi.org/v2/top-headlines?country=$countryCode&apiKey=$_apiKey&sortBy=$sortBy&page=$page";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    return NewsModel.fromJson(json);
  }

  Future<NewsModel> searchNews(String query, int page) async {
    final url =
        "https://newsapi.org/v2/everything?q=$query&apiKey=$_apiKey&page=$page";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    return NewsModel.fromJson(json);
  }

  Future<NewsModel> filterThroughSources(String sortBy,String sources,int page) async{
    final url="https://newsapi.org/v2/everything?sources=$sources&apiKey=$_apiKey&page=$page";
    final response=await http.get(Uri.parse(url));
    final json=jsonDecode(response.body);
    return NewsModel.fromJson(json);
  }

}