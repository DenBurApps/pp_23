import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pp_23/generated/assets.gen.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/presentation/components/settings_button.dart';
import 'package:pp_23/presentation/modules/pages/calc/controller/calc_controller.dart';
import 'package:pull_down_button/pull_down_button.dart';

class CalcView extends StatefulWidget {
  const CalcView({super.key});

  @override
  State<CalcView> createState() => _CalcViewState();
}

class _CalcViewState extends State<CalcView> {
  final _calcController = CalcController();
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _calcController.inputEventController.stream.listen((inputEvent) { 
      switch (inputEvent) {
        case InputEvent.firstInput:
          setState(() {
            _secondController.text = _calcController.value.secondCount.toString();
          });
          break;
          case InputEvent.secondInput:
            setState(() {
            _firstController.text = _calcController.value.firstCount.toString();
          });
          break;
          case InputEvent.empty:
          setState(() {
            _secondController.text = '';
            _firstController.text = '';
          });
    
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 100, top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 50),
                Text(
                  'Calculator',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SettingsButton(),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              color: Theme.of(context).colorScheme.onBackground,
            ),
            SizedBox(height: 39),
            SizedBox(
                height: 380,
                child: ValueListenableBuilder(
                  valueListenable: _calcController.cryptoRepository,
                  builder: (context, value, child) {
                    if (value.isCoinsLoading) {
                      return const _LoadingState();
                    } else if (value.coinsError != null) {
                      return _ErrorState(
                        refresh: _calcController.cryptoRepository.refreshCoins,
                      );
                    } else {
                      return ValueListenableBuilder(
                        valueListenable: _calcController,
                        builder: (context, value, child) => Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _CryptoCard(
                                  controller: _firstController,
                                  onChanged: _calcController.inputFirstValue,
                                  coins: _calcController.allCoinsExceptFirst,
                                  crypto: value.first,
                                  label: 'You send',
                                  select: _calcController.selectFirstCrpyto,
                                ),
                                _CryptoCard(
                                  controller: _secondController,
                                  onChanged: _calcController.inputSecondValue,
                                  coins: _calcController.allCoinsExceptSecond,
                                  crypto: value.second,
                                  label: 'You get',
                                  select: _calcController.selectSecondCrypto,
                                )
                              ],
                            ),
                            _ChangePositionsButton(
                              onPressed: _calcController.changePositions,
                            )
                          ],
                        ),
                      );
                    }
                  },
                )),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Rate',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                ),
                Spacer(),
                ValueListenableBuilder(
                  valueListenable: _calcController,
                  builder: (context, value, child) {
                   final indexOfFirstDigit = value.proportion.toString().indexOf(RegExp(r'[1-9]')) ;
                    return Text(
                   '1 ${value.first.symbol} = ${value.proportion.toStringAsFixed(indexOfFirstDigit)} ${value.second.symbol}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ChangePositionsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ChangePositionsButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        shape: BoxShape.circle,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          child: Assets.icons.change.svg(fit: BoxFit.none),
        ),
      ),
    );
  }
}

class _CryptoCard extends StatelessWidget {
  final Crypto crypto;
  final String label;
  final void Function(Crypto) select;
  final List<Crypto> coins;
  final void Function(String) onChanged;
  final TextEditingController controller;
  const _CryptoCard({
    required this.crypto,
    required this.label,
    required this.select,
    required this.coins,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: crypto.iconUrl.contains('.png')
                    ? Image.network(
                        crypto.iconUrl,
                        width: 38,
                        height: 38,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      )
                    : SvgPicture.network(
                        crypto.iconUrl,
                        width: 38,
                        height: 38,
                      ),
              ),
              SizedBox(width: 5),
              PullDownButton(
                itemBuilder: (context) => List.generate(
                  coins.length,
                  (index) => PullDownMenuItem(
                    onTap: () => select.call(coins[index]),
                    title: coins[index].symbol,
                  ),
                ),
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: showMenu,
                  child: Row(
                    children: [
                      Text(
                        '${crypto.symbol}',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(width: 5),
                      Assets.icons.chevronDown.svg(
                        color: Theme.of(context).colorScheme.onSurface,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CupertinoTextField(
                  textAlign: TextAlign.end,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(color: Colors.transparent),
                  placeholder: '0.00',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  placeholderStyle:
                      Theme.of(context).textTheme.displayMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                  onChanged: onChanged,
                  controller: controller,
                
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 11),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 29, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xFF5393FF),
            ),
            child: Text(
              crypto.name,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          Divider(
            height: 40,
            color: Theme.of(context).colorScheme.onSurface,
            thickness: 1,
          ),
        ],
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

class _ErrorState extends StatelessWidget {
  final VoidCallback? refresh;
  const _ErrorState({this.refresh});

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
            child: Icon(Icons.refresh_outlined, size: 30),
            onPressed: refresh,
          ),
        ],
      ),
    );
  }
}
