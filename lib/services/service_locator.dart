import 'package:get_it/get_it.dart';
import 'package:pp_23/services/crypto_api_service.dart';
import 'package:pp_23/services/database/database_service.dart';
import 'package:pp_23/services/news_api_service.dart';
import 'package:pp_23/services/remote_config_service.dart';
import 'package:pp_23/services/repositories/crypto_repository.dart';
import 'package:pp_23/services/repositories/news_repository.dart';

class ServiceLocator {
  static Future<void> setup() async {
    GetIt.I.registerSingletonAsync(() => DatabaseService().init());
    await GetIt.I.isReady<DatabaseService>();
    GetIt.I.registerSingletonAsync(() => RemoteConfigService().init());
    await GetIt.I.isReady<RemoteConfigService>();
    GetIt.I.registerSingleton<CryptoApiService>(CryptoApiService().init());
    GetIt.I.registerSingleton<NewsApiService>(NewsApiService().init());

    GetIt.I.registerSingleton<NewsRepository>(NewsRepository().init());
    GetIt.I.registerSingleton<CryptoRepository>(CryptoRepository().init());
  }
}
