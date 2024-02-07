import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_23/models/crypto.dart';
import 'package:pp_23/services/repositories/crypto_repository.dart';

class CalcController extends ValueNotifier<CalcState> {
  CalcController()
      : super(
          CalcState.initial(
            first: _cryptoRepository.first,
            second: _cryptoRepository.second,
          ),
        ) {
          _init();
        }

  static final _cryptoRepository = GetIt.instance<CryptoRepository>();

final inputEventController = StreamController<InputEvent>();

CryptoRepository get cryptoRepository => _cryptoRepository;

  List<Crypto> get allCoinsExceptFirst => _cryptoRepository.value.coins
      .where((element) => element != value.first)
      .toList();

  List<Crypto> get allCoinsExceptSecond => _cryptoRepository.value.coins
      .where((element) => element != value.second)
      .toList();

  void _init() {
    value = value.copyWith(proportion: value.first.price/value.second.price);
  }

  void selectFirstCrpyto(Crypto crypto) {
    final proportion = (crypto.price / value.second.price);
    final secondCount = value.firstCount * proportion;
    value = value.copyWith(
      first: crypto,
      secondCount: secondCount,
      proportion: proportion
    );
     inputEventController.sink.add(InputEvent.firstInput);
     inputEventController.sink.add(InputEvent.secondInput);
  }

  void selectSecondCrypto(Crypto crypto) {
    final proportion = (crypto.price / value.first.price);
    final firstCount = value.secondCount * proportion;
    value = value.copyWith(
      second: crypto,
      firstCount: firstCount,
      proportion: proportion
    );
     inputEventController.sink.add(InputEvent.firstInput);
     inputEventController.sink.add(InputEvent.secondInput);
  }

  void changePositions() {
    final second = value.second;
    final proportion = (value.second.price / value.first.price);
    final secondCount = value.firstCount * proportion;

    value = value.copyWith(
      second: value.first,
      first: second,
      secondCount: secondCount,
      proportion: proportion
    );
    inputEventController.sink.add(InputEvent.firstInput);
     inputEventController.sink.add(InputEvent.secondInput);
  }


  void inputFirstValue(String input) {
   if (input.isEmpty) {
    value = value.copyWith(firstCount: 0, secondCount: 0);
    inputEventController.sink.add(InputEvent.empty);
return;
   } else {
     value = value.copyWith(proportion: value.first.price/value.second.price);
    
    final firstCount = double.parse(input);
    final secondCount = firstCount * value.proportion;
    value = value.copyWith(firstCount: firstCount, secondCount: secondCount);
      inputEventController.sink.add(InputEvent.firstInput);
   }
  
  }

  void inputSecondValue(String input) {
    if (input.isEmpty) {
     value = value.copyWith(firstCount: 0, secondCount: 0);
      inputEventController.sink.add(InputEvent.empty);
    }
    else {
      value = value.copyWith(proportion: value.second.price/value.first.price);

    final secondCount = double.parse(input);
    final firstCount = secondCount * value.proportion;
    value = value.copyWith(firstCount: firstCount, secondCount: secondCount);
         inputEventController.sink.add(InputEvent.secondInput);
    }

  }
}

class CalcState {
  final double firstCount;
  final double secondCount;
  final double proportion;
  final Crypto first;
  final Crypto second;

  const CalcState({
    required this.firstCount,
    required this.secondCount,
    required this.first,
    required this.second,
    required this.proportion, 
  });

  factory CalcState.initial({
    required Crypto first,
    required Crypto second,
  }) =>
      CalcState(
        first: first,
        second: second,
        firstCount: 0,
        secondCount: 0,
        proportion: 0, 
      );

  CalcState copyWith({
    Crypto? first,
    Crypto? second,
    double? firstCount,
    double? secondCount,
    double? proportion, 
  }) =>
      CalcState(
        first: first ?? this.first,
        second: second ?? this.second,
        firstCount: firstCount ?? this.firstCount,
        secondCount: secondCount ?? this.secondCount,
        proportion: proportion ?? this.proportion
      );
}

enum InputEvent {
  empty, 
  firstInput, 
  secondInput, 
}
