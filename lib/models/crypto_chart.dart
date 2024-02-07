class CryptoChart {
  final String change;
  final List<CryptoTimestamp> timestamps;

  const CryptoChart({
    required this.change,
    required this.timestamps,
  });

  factory CryptoChart.fromJson(Map<String, dynamic> json) => CryptoChart(
        change: json['change'],
        timestamps: (json['history'] as List<dynamic>)
            .map((e) => CryptoTimestamp.fromJson(e))
            .toList(),
      );

  factory CryptoChart.initial() =>  const CryptoChart(
        change: '',
        timestamps: [],
      );
}

class CryptoTimestamp {
  final int timestamp;
  final String price;

  const CryptoTimestamp({
    required this.timestamp,
    required this.price,
  });

  factory CryptoTimestamp.fromJson(Map<String, dynamic> json) =>
      CryptoTimestamp(
        timestamp: json['timestamp'],
        price: json['price'],
      );
}

