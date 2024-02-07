import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pp_23/models/arguments.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/models/crypto_chart.dart';
import 'package:pp_23/presentation/components/app_back_button.dart';
import 'package:pp_23/presentation/components/settings_button.dart';
import 'package:pp_23/presentation/components/shimmers.dart';
import 'package:pp_23/presentation/modules/pages/home/controller/single_crypto_controller.dart';
import 'package:pp_23/theme/custom_colors.dart';

class SingleCryptoView extends StatefulWidget {
  final SingleCryptoViewArguments arguments;
  const SingleCryptoView({
    super.key,
    required this.arguments,
  });

  factory SingleCryptoView.crate(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as SingleCryptoViewArguments;
    return SingleCryptoView(arguments: arguments);
  }

  @override
  State<SingleCryptoView> createState() => _SingleCryptoViewState();
}

class _SingleCryptoViewState extends State<SingleCryptoView> {
  Crypto get _crypto => widget.arguments.crypto;

  late final _singleCryptoController = SingleCryptoController(
    SingleCryptoState(
      crypto: _crypto,
      chart: CryptoChart.initial(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBackButton(),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        _crypto.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                      ),
                      Text(
                        _crypto.symbol,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5),
                                ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SettingsButton(),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 73,
                  height: 73,
                  child: _crypto.iconUrl.contains('.png')
                      ? Image.network(
                          _crypto.iconUrl,
                          width: 73,
                          height: 73,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(),
                        )
                      : SvgPicture.network(
                          _crypto.iconUrl,
                          width: 73,
                          height: 73,
                        ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ValueListenableBuilder(
                  valueListenable: _singleCryptoController,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return ShimmerWidget(
                        size: Size(double.infinity, 70),
                      );
                    } else if (value.errorMessage != null) {
                      return SizedBox.shrink();
                    } else {
                      final price =
                          double.parse(value.chart.timestamps.first.price);
                      final change = double.parse(value.chart.change);
                      final isNegative = change.isNegative;
                      final percentage =
                          '${(change / price).toStringAsFixed(2)} %';
                      return Column(
                        children: [
                          Text(
                            '\$${price.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                          ),
                          SizedBox(height: 20),
                          _PercentageContainer(
                            percantage: percentage,
                            isNegative: isNegative,
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 38,
                child: ValueListenableBuilder(
                  valueListenable: _singleCryptoController,
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      ChartTimestamp.values.length,
                      (index) => _Timestamp(
                        timestamp: ChartTimestamp.values[index],
                        onPressed: () =>
                            _singleCryptoController.changeTimestamp(
                          ChartTimestamp.values[index],
                        ),
                        isActive: ChartTimestamp.values[index] ==
                            value.chartTimestamp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _singleCryptoController,
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return ShimmerWidget(
                      size: Size(double.infinity, 270),
                    );
                  } else if (value.errorMessage != null) {
                    return _ErrorState(
                      refresh: _singleCryptoController.refreshChart,
                    );
                  } else {
                    return _Chart(chart: value.chart);
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'About',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: _singleCryptoController,
                builder: (context, value, child) {
                  if (value.isDescriptionLoading) {
                    return ShimmerWidget(
                      size: Size(
                        double.infinity,
                        80,
                      ),
                    );
                  } else if (value.descriptionError != null) {
                    return _ErrorState(
                      refresh: _singleCryptoController.refreshDescription,
                    );
                  } else {
                    return Text(
                      value.description!,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final CryptoChart chart;
  const _Chart({required this.chart});

  @override
  Widget build(BuildContext context) {
    final isNegative = double.parse(chart.change).isNegative;
    final values = chart.timestamps.reversed.toList();
    final sorted = List.from(chart.timestamps)
      ..sort((a, b) {
        final firstPrice = double.parse(a.price);
        final secondPrice = double.parse(b.price);
        return firstPrice.compareTo(secondPrice);
      });

    final maxPrice = double.parse(sorted.last.price);
    final minY = double.parse(sorted.first.price);
    return Container(
      height: 239,
      padding: EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.26),
              getTooltipItems: (touchedSpots) => touchedSpots
                  .map(
                    (e) => LineTooltipItem(
                      '${e.y.toStringAsFixed(2)}\$',
                      Theme.of(context).textTheme.displaySmall!,
                    ),
                  )
                  .toList(),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  meta.formattedValue,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
            bottomTitles: AxisTitles(),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
          borderData: FlBorderData(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          gridData: FlGridData(
            checkToShowHorizontalLine: (value) => true,
            checkToShowVerticalLine: (value) => true,
            getDrawingHorizontalLine: (value) => FlLine(
              strokeWidth: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            getDrawingVerticalLine: (value) => FlLine(
              strokeWidth: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              barWidth: 2,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    isNegative
                        ? Theme.of(context)
                            .extension<CustomColors>()!
                            .red
                            .withOpacity(0.3)
                        : Theme.of(context)
                            .extension<CustomColors>()!
                            .green
                            .withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              spots: List.generate(
                values.length,
                (index) => FlSpot(
                  index.toDouble(),
                  double.parse(values[index].price),
                ),
              ),
              dotData: FlDotData(show: false),
              color: isNegative
                  ? Theme.of(context).extension<CustomColors>()!.red
                  : Theme.of(context).extension<CustomColors>()!.green,
            ),
          ],
          minY: minY,
          minX: 0,
          maxX: chart.timestamps.length.toDouble(),
          maxY: maxPrice,
        ),
      ),
    );
  }
}

class _Timestamp extends StatelessWidget {
  final ChartTimestamp timestamp;
  final VoidCallback onPressed;
  final bool isActive;
  const _Timestamp({
    required this.timestamp,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 40,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: isActive
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          timestamp.label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: isActive
                    ? Theme.of(context).colorScheme.background
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}

class _PercentageContainer extends StatelessWidget {
  final String percantage;
  final bool isNegative;
  const _PercentageContainer({
    required this.percantage,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 74,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isNegative
            ? Theme.of(context).extension<CustomColors>()!.red
            : Theme.of(context).extension<CustomColors>()!.green,
      ),
      child: Text(
        percantage,
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Colors.white),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback refresh;
  const _ErrorState({required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Some error has occured.\nPlease, try again!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.replay_circle_filled_rounded),
            onPressed: refresh,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
