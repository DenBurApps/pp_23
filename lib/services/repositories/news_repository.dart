import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/models/news.dart';
import 'package:pp_23/services/news_api_service.dart';

class NewsRepository extends ValueNotifier<NewsState> {
  NewsRepository() : super(NewsState.inital());

  NewsRepository init() {
    _loadNews();
    return this;
  }

  final _newsApiService = GetIt.instance<NewsApiService>();

  Future<void> _loadNews() async {
    try {
      value = value.copyWith(isLoading: true);
      final articles = await _newsApiService.getNews();
      value = value.copyWith(isLoading: false, news: articles);
    } catch (e) {
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> refresh() async => await _loadNews();

  Future<void> scrollRefresh() async {
    try {
      final articles = await _newsApiService.getNews();
      value = value.copyWith(isLoading: false, news: articles);
    } catch (e) {
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

class NewsState {
  final List<News> news;
  final bool isLoading;
  final String? errorMessage;

  const NewsState({
    required this.news,
    required this.isLoading,
    this.errorMessage,
  });

  factory NewsState.inital() => NewsState(
        news: [],
        isLoading: false,
      );

  NewsState copyWith({
    List<News>? news,
    bool? isLoading,
    String? errorMessage,
  }) =>
      NewsState(
        news: news ?? this.news,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
