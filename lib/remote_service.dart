import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/news_model.dart';

class NewsApi {
  final String apiKey;
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  static const String _countryCode =
      'us'; // Change to your desired country code

  NewsApi(this.apiKey);

  Future<List<NewsArticle>> getTopHeadlines() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?country=$_countryCode&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articles = jsonData['articles'] as List<dynamic>;

      return articles
          .map((article) => NewsArticle(
                title: article['title'] ?? '',
                description: article['description'] ?? '',
                url: article['url'] ?? '',
                imageUrl: article['urlToImage'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}
