import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/models/crypto_chart.dart';
import 'package:pp_23/services/crypto_api_service.dart';

class SingleCryptoController extends ValueNotifier<SingleCryptoState> {
  SingleCryptoController(super.value) {
    _init();
    _getDescription();
  }

  final _cryptoApiService = GetIt.instance<CryptoApiService>();

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);

      final cryptoChart = await _cryptoApiService.getCoinChart(
        coin: value.crypto,
        chartTimestamp: value.chartTimestamp,
      );
      value = value.copyWith(
        isLoading: false,
        chart: cryptoChart,
      );
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshChart() async => await _init();

  void changeTimestamp(ChartTimestamp chartTimestamp) {
    value = value.copyWith(chartTimestamp: chartTimestamp);
    refreshChart();
  }

  Future<void> _getDescription() async {
    try {
      value = value.copyWith(isDescriptionLoading: true);

      final description = await _cryptoApiService.getCoinDescription(
        coin: value.crypto,
      );
      value = value.copyWith(
        isDescriptionLoading: false,
        description: description,
      );
    } catch (e) {
      value = value.copyWith(
        isDescriptionLoading: false,
        descriptionError: e.toString(),
      );
    }
  }

  void refreshDescription() => _getDescription();
}

class SingleCryptoState {
  final Crypto crypto;
  final CryptoChart chart;
  final bool isLoading;
  final ChartTimestamp chartTimestamp;
  final String? errorMessage;
  final String? description;
  final bool isDescriptionLoading;
  final String? descriptionError;

  const SingleCryptoState({
    required this.crypto,
    required this.chart,
    this.isLoading = false,
    this.errorMessage,
    this.chartTimestamp = ChartTimestamp.r7d,
    this.isDescriptionLoading = false,
    this.descriptionError,
    this.description,
  });

  SingleCryptoState copyWith({
    CryptoChart? chart,
    bool? isLoading,
    ChartTimestamp? chartTimestamp,
    String? errorMessage,
    bool? isDescriptionLoading,
    String? descriptionError,
    String? description,
  }) =>
      SingleCryptoState(
        crypto: crypto,
        chart: chart ?? this.chart,
        isLoading: isLoading ?? this.isLoading,
        chartTimestamp: chartTimestamp ?? this.chartTimestamp,
        errorMessage: errorMessage ?? this.errorMessage,
        isDescriptionLoading: isDescriptionLoading ?? this.isDescriptionLoading,
        descriptionError: descriptionError ?? this.descriptionError,
        description: description ?? this.description,
      );
}

enum ChartTimestamp {
  r24h(label: '24h'),
  r7d(label: '7d'),
  r30d(label: '30d'),
  r3m(label: '3m'),
  r1y(label: '1y');

  final String label;

  const ChartTimestamp({required this.label});
}