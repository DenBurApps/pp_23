import 'package:equatable/equatable.dart';

class Crypto extends Equatable {
  final String iconUrl;
  final double price;
  final double change;
  final String name;
  final String symbol;
  final String uuid;

  const Crypto({
    required this.iconUrl,
    required this.uuid,
    required this.price,
    required this.change,
    required this.name,
    required this.symbol,
  });

  factory Crypto.fromjson(Map<String, dynamic> json) => Crypto(
        iconUrl: json['iconUrl'],
        price: double.parse(json['price']),
        change: double.parse(json['change']),
        name: json['name'],
        symbol: json['symbol'],
        uuid: json['uuid'],
      );

  @override
  List<Object?> get props => [uuid];
}
