import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/models/arguments.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/presentation/components/app_button.dart';
import 'package:pp_23/presentation/components/settings_button.dart';
import 'package:pp_23/routes/routes.dart';
import 'package:pp_23/services/crypto_api_service.dart';
import 'package:pp_23/services/repositories/crypto_repository.dart';
import 'package:pp_23/theme/custom_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cryptoRepository = GetIt.instance<CryptoRepository>();

  void _edit() => showCupertinoModalPopup(
        context: context,
        builder: (context) => ValueListenableBuilder(
          valueListenable: _cryptoRepository,
          builder: (context, value, child) => _EditPopUp(
            coins: value.coins,
            watchlist: value.watchlist,
            addCoin: _cryptoRepository.addToWatchlist,
            isLoading: value.isCoinsLoading,
            errorMessage: value.coinsError,
            refresh: _cryptoRepository.refreshCoins,
            scrollRefresh: _cryptoRepository.refreshCoinsOnScroll,
            deleteCoin: _cryptoRepository.deleteFromWatchlist,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(12),
                  child: Assets.images.icon.image(
                  width: 60, 
                  height: 60
                ),),
                const SettingsButton(),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(height: 20),
            _SortPanel(
              high: () => _cryptoRepository.sortWatchlist(SortType.high),
              low: () => _cryptoRepository.sortWatchlist(SortType.low),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Watchlist',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                Spacer(),
                CupertinoButton(
                  child: Text(
                    'Edit',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                  onPressed: _edit,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: ValueListenableBuilder(
                valueListenable: _cryptoRepository,
                builder: (context, value, child) {
                  if (value.isWatchlistLoading) {
                    return const _LoadingState();
                  } else if (value.watchlistError != null) {
                    return _ErrorState(
                      errorMessage: value.coinsError!,
                      refresh: _cryptoRepository.refreshCoins,
                    );
                  } else {
                    return _Watchlist(
                      scrollRefresh: _cryptoRepository.refreshWatchlistOnScroll,
                      watchlist: value.watchlist,
                      delete: _cryptoRepository.deleteFromWatchlist,
                      edit: _edit,
                    );
                  }
                },
              ),
            )),
            SizedBox(height: 100)
          ],
        ),
      ),
    );
  }
}

class _Watchlist extends StatelessWidget {
  final List<Crypto> watchlist;
  final VoidCallback edit;
  final void Function(Crypto) delete;

  final Future<void> Function() scrollRefresh;
  const _Watchlist({
    required this.watchlist,
    required this.edit,
    required this.scrollRefresh,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return watchlist.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your watchlist is empty!'),
              SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: AppButton(onPressed: edit, label: 'Edit'),
              ),
            ],
          )
        : RefreshIndicator.adaptive(
            onRefresh: scrollRefresh,
            color: Theme.of(context).colorScheme.onBackground,
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, index) => CupertinoContextMenu(
                previewBuilder: (context, animation, child) => _ShortedCoinData(
                  coin: watchlist[index],
                ),
                actions: [
                  CupertinoContextMenuAction(
                    child: Text('See more'),
                    onPressed: () => Navigator.of(context).popAndPushNamed(
                      RouteNames.singleCrypto,
                      arguments: SingleCryptoViewArguments(
                        crypto: watchlist[index],
                      ),
                    ),
                  ),
                  CupertinoContextMenuAction(
                    isDestructiveAction: true,
                    child: Text('Delete'),
                    onPressed: () {
                      delete.call(watchlist[index]);
                      Navigator.of(context).pop();
                    },
                  )
                ],
                child: _CryptoTile(
                  useDecoration: true,
                  crypto: watchlist[index],
                  onPressed: () => Navigator.of(context).pushNamed(
                    RouteNames.singleCrypto,
                    arguments: SingleCryptoViewArguments(
                      crypto: watchlist[index],
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Divider(
                height: 30,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              itemCount: watchlist.length,
            ),
          );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}

class _ShortedCoinData extends StatefulWidget {
  final Crypto coin;
  const _ShortedCoinData({required this.coin});

  @override
  State<_ShortedCoinData> createState() => _ShortedCoinDataState();
}

class _ShortedCoinDataState extends State<_ShortedCoinData> {
  final _cryptoApiService = GetIt.instance<CryptoApiService>();

  Crypto get _coin => widget.coin;

  var _isLoading = false;

  var _hasError = false;

  var _description = '';

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    try {
      setState(() => _isLoading = true);
      final description =
          await _cryptoApiService.getCoinDescription(coin: _coin);
      if (!context.mounted) return;
      setState(() {
        _isLoading = false;
        _description = description;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _refresh() => _init();

  @override
  Widget build(BuildContext context) {
    final isNegative = _coin.change.isNegative;
    final changePercantage = _coin.change / _coin.price;
    ;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 60,
              height: 60,
              child: _coin.iconUrl.contains('.png')
                  ? Image.network(
                      _coin.iconUrl,
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    )
                  : SvgPicture.network(
                      _coin.iconUrl,
                      width: 60,
                      height: 60,
                    ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    _coin.name,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    _coin.symbol,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_coin.price.toStringAsFixed(2)}\$',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                  ),
                  Text(
                    '${isNegative ? '' : '+'}${_coin.change.toStringAsFixed(2)}\$ (${isNegative ? '' : '+'}${changePercantage.toStringAsFixed(4)}%)',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isNegative
                              ? Theme.of(context).extension<CustomColors>()!.red
                              : Theme.of(context)
                                  .extension<CustomColors>()!
                                  .green,
                        ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? _LoadingState()
                : _hasError
                    ? _ErrorState(
                        refresh: _refresh,
                      )
                    : Material(
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Text(_description),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? refresh;
  const _ErrorState({
    this.errorMessage,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some error has occured',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.refresh_outlined,
              size: 30,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: refresh,
          ),
        ],
      ),
    );
  }
}

class _SortPanel extends StatelessWidget {
  final VoidCallback high;
  final VoidCallback low;
  const _SortPanel({
    required this.high,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.high
                    .svg(color: Theme.of(context).colorScheme.onBackground),
                SizedBox(width: 5),
                Text(
                  'High',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
            onPressed: high,
          ),
          SizedBox(
            height: 26,
            child: VerticalDivider(
              color: Theme.of(context).colorScheme.onBackground,
              thickness: 1,
              width: 62,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.low
                    .svg(color: Theme.of(context).colorScheme.onBackground),
                SizedBox(width: 5),
                Text(
                  'Low',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
            onPressed: low,
          ),
        ],
      ),
    );
  }
}

class _EditPopUp extends StatelessWidget {
  final List<Crypto> coins;
  final List<Crypto> watchlist;
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback refresh;
  final Future<void> Function() scrollRefresh;
  final void Function(Crypto) addCoin;
  final void Function(Crypto) deleteCoin;

  const _EditPopUp({
    required this.coins,
    required this.watchlist,
    required this.isLoading,
    required this.errorMessage,
    required this.refresh,
    required this.scrollRefresh,
    required this.addCoin,
    required this.deleteCoin,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 30,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: isLoading
            ? const _LoadingState()
            : errorMessage != null
                ? _ErrorState(errorMessage: errorMessage!, refresh: refresh)
                : RefreshIndicator.adaptive(
                  color: Theme.of(context).colorScheme.onBackground,
                    onRefresh: scrollRefresh,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 9),
                            Text(
                              'Edit',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                            GestureDetector(
                              child: Assets.icons.close.svg(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              onTap: Navigator.of(context).pop,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(top: 20),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final coin = coins[index];
                              final isInWatchlist = watchlist.contains(coin);
                              return _CryptoTile(
                                crypto: coins[index],
                                isInWatchlist: isInWatchlist,
                                onPressed: () => isInWatchlist
                                    ? deleteCoin.call(coin)
                                    : addCoin.call(coin),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                              height: 30,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                            itemCount: coins.length,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _CryptoTile extends StatelessWidget {
  final Crypto crypto;
  final bool isInWatchlist;
  final bool useDecoration;
  final VoidCallback? onPressed;

  const _CryptoTile({
    super.key,
    required this.crypto,
    this.onPressed,
    this.isInWatchlist = false,
    this.useDecoration = false,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = crypto.change.isNegative;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        decoration: useDecoration
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              )
            : null,
        padding: EdgeInsets.only(left: 10, right: 16),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isInWatchlist) ...[
              Icon(
                Icons.done,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 10),
            ],
            SizedBox(
              width: 38,
              height: 38,
              child: crypto.iconUrl.contains('.png')
                  ? Image.network(
                      crypto.iconUrl,
                      width: 37,
                      height: 37,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    )
                  : SvgPicture.network(
                      crypto.iconUrl,
                      width: 37,
                      height: 37,
                    ),
            ),
            SizedBox(width: 17),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: Theme.of(context).textTheme.displaySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 5),
                    Text(
                      crypto.symbol,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    child: Row(
                      children: [
                        if (isNegative)
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: isNegative
                                ? Theme.of(context)
                                    .extension<CustomColors>()!
                                    .red
                                : Theme.of(context)
                                    .extension<CustomColors>()!
                                    .green,
                          )
                        else
                          Icon(
                            Icons.arrow_drop_up_rounded,
                            color: isNegative
                                ? Theme.of(context)
                                    .extension<CustomColors>()!
                                    .red
                                : Theme.of(context)
                                    .extension<CustomColors>()!
                                    .green,
                          ),
                        SizedBox(width: 20),
                        Text(
                          '${isNegative ? '' : '+'}${crypto.change.toStringAsFixed(2)}\$',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: isNegative
                                        ? Theme.of(context)
                                            .extension<CustomColors>()!
                                            .red
                                        : Theme.of(context)
                                            .extension<CustomColors>()!
                                            .green,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${crypto.price.toStringAsFixed(2)}\$',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
