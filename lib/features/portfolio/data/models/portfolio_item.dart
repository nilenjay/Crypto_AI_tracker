import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioItem {
  final String coinId;
  final String symbol;
  final String name;
  final double amount;
  final double buyPrice;
  final DateTime buyDate;

  PortfolioItem({
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.amount,
    required this.buyPrice,
    required this.buyDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'coinId': coinId,
      'symbol': symbol,
      'name': name,
      'amount': amount,
      'buyPrice': buyPrice,
      'buyDate': Timestamp.fromDate(buyDate),
    };
  }

  factory PortfolioItem.fromMap(String id, Map<String, dynamic> map) {
    return PortfolioItem(
      coinId: map['coinId'] ?? id,
      symbol: map['symbol'] ?? '',
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      buyPrice: (map['buyPrice'] ?? 0.0).toDouble(),
      buyDate: (map['buyDate'] as Timestamp).toDate(),
    );
  }

  PortfolioItem copyWith({
    String? coinId,
    String? symbol,
    String? name,
    double? amount,
    double? buyPrice,
    DateTime? buyDate,
  }) {
    return PortfolioItem(
      coinId: coinId ?? this.coinId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      buyPrice: buyPrice ?? this.buyPrice,
      buyDate: buyDate ?? this.buyDate,
    );
  }
}
