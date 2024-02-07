import 'dart:convert';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/models/crypto_chart.dart';
import 'package:pp_23/presentation/modules/pages/home/controller/single_crypto_controller.dart';
import 'package:pp_23/services/remote_config_service.dart';

class CryptoApiService {
  final _remoteConfigService = GetIt.instance<RemoteConfigService>();
  late final String _apiKey;

  Map<String, String> get _headers => {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
      };

  CryptoApiService init() {
    _apiKey = _remoteConfigService.getString(ConfigKey.cryptoApiKey);
    return this;
  }

  Future<List<Crypto>> getCoins() async {
    List<Crypto> coins = [];
    try {
      final response = await http.get(
          Uri.parse('https://coinranking1.p.rapidapi.com/coins'),
          headers: _headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data']['coins'] as List<dynamic>;
        for (var coin in data) {
          coins.add(Crypto.fromjson(coin));
        }
        return coins;
      } else {
        log(response.statusCode.toString());
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<CryptoChart> getCoinChart({
    required Crypto coin,
    required ChartTimestamp chartTimestamp,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://coinranking1.p.rapidapi.com/coin/${coin.uuid}/history?timePeriod=${chartTimestamp.label}'),
        headers: {
          'X-RapidAPI-Key':
              _remoteConfigService.getString(ConfigKey.cryptoApiKey),
          'X-RapidAPI-Host': 'coinranking1.p.rapidapi.com'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];

        return CryptoChart.fromJson(json);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getCoinDescription({
    required Crypto coin,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/coin/${coin.uuid}'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final description =
            jsonDecode(response.body)['data']['coin']['description'];

        return description;
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Crypto> getCoin(String uuid) async {
    try {
      final response = await http.get(
        Uri.parse('https://coinranking1.p.rapidapi.com/coin/$uuid'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data']['coin'];
        return Crypto.fromjson(json);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
