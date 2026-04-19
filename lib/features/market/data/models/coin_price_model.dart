class CoinPriceModel {
  final String coinId;
  final double priceUsd;
  final double change24hPct;

  CoinPriceModel({
    required this.coinId,
    required this.priceUsd,
    required this.change24hPct,
  });

  factory CoinPriceModel.fromJson(Map<String, dynamic> json) {
    return CoinPriceModel(
      coinId: json['coin_id'] ?? '',
      priceUsd: (json['price_usd'] as num?)?.toDouble() ?? 0.0,
      change24hPct: (json['change_24h_pct'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
