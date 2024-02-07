import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:pp_23/models/news.dart';
import 'package:pp_23/services/remote_config_service.dart';

class NewsApiService {
  final _remoteConfigService = GetIt.instance<RemoteConfigService>();

  late final String _apiKey;

  Map<String, String> get _headers => {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'google-api31.p.rapidapi.com'
      };

  NewsApiService init() {
    _apiKey = _remoteConfigService.getString(ConfigKey.newsApiKey);
    return this;
  }

  Future<List<News>> getNews() async {
    try {
      List<News> articles = [];
      final data = {
        "text": "Crypto",
        "region": "wt-wt",
        "max_results": 25,
        "time_limit": "d"
      };
      final response = await post(
          Uri.parse('https://google-api31.p.rapidapi.com/'),
          body: jsonEncode(data),
          headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final json = data['news'] as List<dynamic>;
        for (var articleJson in json) {
          articles.add(News.fromJson(articleJson));
        }
        return articles;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
