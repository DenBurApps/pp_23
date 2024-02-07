import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/services/crypto_api_service.dart';
import 'package:pp_23/services/database/database_service.dart';

class CryptoRepository extends ValueNotifier<CryptoState> {
  CryptoRepository() : super(CryptoState.inital());

  final _cryptoApiService = GetIt.instance<CryptoApiService>();
  final _databaseService = GetIt.instance<DatabaseService>();

  CryptoRepository init() {
    _loadCoins();
    _loadWatchlist();
    return this;
  }

  Crypto get first => value.coins.first;

  Crypto get second => value.coins[1];

  Future<void> _loadCoins() async {
    try {
      value = value.copyWith(
        isLoading: true,
      );
      final coins = await _cryptoApiService.getCoins();
      value = value.copyWith(coins: coins, isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void refreshCoins() => _loadCoins();

  Future<void> refreshCoinsOnScroll() async {
    try {
      final coins = await _cryptoApiService.getCoins();
      value = value.copyWith(coins: coins, isLoading: false);
    } catch (e) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _loadWatchlist() async {
    try {
      value = value.copyWith(isWatchlistLoading: true);
      List<Crypto> watchlist = [];
      final watchlistIds = _databaseService.watchlistIds;
      for (var cryptoId in watchlistIds) {
        final crypto = await _cryptoApiService.getCoin(cryptoId);
        watchlist.add(crypto);
      }
      value = value.copyWith(isWatchlistLoading: false, watchlist: watchlist);
    } catch (e) {
      value = value.copyWith(
        isWatchlistLoading: false,
        watchlistError: e.toString(),
      );
    }
  }

  void refreshWatchlist() => _loadWatchlist();

  Future<void> refreshWatchlistOnScroll() async {
    try {
      List<Crypto> watchlist = [];
      final watchlistIds = _databaseService.watchlistIds;
      for (var cryptoId in watchlistIds) {
        final crypto = await _cryptoApiService.getCoin(cryptoId);
        watchlist.add(crypto);
      }
      value = value.copyWith(isWatchlistLoading: false, watchlist: watchlist);
    } catch (e) {
      value = value.copyWith(
        isWatchlistLoading: false,
        watchlistError: e.toString(),
      );
    }
  }

  void sortWatchlist(SortType sortStatus) {
    if (sortStatus == SortType.high) {
      value.watchlist.sort((a, b) {
        if (b.price > a.price) {
          return 1;
        } else {
          return 0;
        }
      });
    } else {
      value.watchlist.sort((a, b) {
        if (b.price < a.price) {
          return 1;
        } else {
          return 0;
        }
      });
    }
    notifyListeners();
  }

  void addToWatchlist(Crypto crypto) {
    if (value.watchlist.contains(crypto)) return;
    value.watchlist.add(crypto);
    _databaseService.addCoin(crypto.uuid);
    notifyListeners();
  }

  void deleteFromWatchlist(Crypto crypto) {
    final index = value.watchlist.indexOf(crypto);
    value.watchlist.removeAt(index);
    _databaseService.removeCoin(index);
    notifyListeners();
  }
}

class CryptoState {
  final List<Crypto> coins;
  final List<Crypto> watchlist;
  final bool isCoinsLoading;
  final bool isWatchlistLoading;
  final String? watchlistError;
  final String? coinsError;

  const CryptoState({
    required this.coins,
    required this.watchlist,
    required this.isCoinsLoading,
    required this.isWatchlistLoading,
    this.watchlistError,
    this.coinsError,
  });

  factory CryptoState.inital() => CryptoState(
        coins: [],
        watchlist: [],
        isWatchlistLoading: false,
        isCoinsLoading: false,
      );

  CryptoState copyWith({
    List<Crypto>? coins,
    List<Crypto>? watchlist,
    bool? isLoading,
    String? errorMessage,
    bool? isWatchlistLoading,
    String? watchlistError,
  }) =>
      CryptoState(
        isWatchlistLoading: isWatchlistLoading ?? this.isWatchlistLoading,
        watchlistError: watchlistError ?? this.watchlistError,
        watchlist: watchlist ?? this.watchlist,
        coins: coins ?? this.coins,
        isCoinsLoading: isLoading ?? this.isCoinsLoading,
        coinsError: errorMessage ?? this.coinsError,
      );
}

enum SortType {
  low,
  high,
}
