class CoinGraphModel {
  final String coinId;
  final List<List<double>> prices; 

  CoinGraphModel({
    required this.coinId,
    required this.prices,
  });

  factory CoinGraphModel.fromJson(Map<String, dynamic> json) {
    final pricesRaw = json['prices'] as List<dynamic>? ?? [];
    List<List<double>> parsedPrices = [];
    for (var point in pricesRaw) {
      if (point is List && point.length == 2) {
        parsedPrices.add([
          (point[0] as num).toDouble(),
          (point[1] as num).toDouble(),
        ]);
      }
    }

    return CoinGraphModel(
      coinId: json['coin_id'] ?? '',
      prices: parsedPrices,
    );
  }
}
