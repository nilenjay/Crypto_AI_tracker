import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_item.dart';

enum PortfolioStatus { initial, loading, success, error }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final List<PortfolioItem> items;
  final Map<String, double> currentPrices; // coinId -> priceUsd
  final String? errorMessage;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.items = const [],
    this.currentPrices = const {},
    this.errorMessage,
  });

  // Aggregated Stat Calculations
  double get totalInvested {
    return items.fold(0.0, (sum, item) => sum + (item.amount * item.buyPrice));
  }

  double get currentTotalValue {
    // Current value = sum(amount * currentMarketPrice)
    return items.fold(0.0, (sum, item) {
      final currentPrice = currentPrices[item.coinId] ?? item.buyPrice; // fallback to buyPrice if current not available
      return sum + (item.amount * currentPrice * 83.0); // Convert to INR approx if needed, but let's keep logic consistent
    });
  }

  // Value in INR (since UI uses ₹)
  double get totalInvestedInr => totalInvested * 83.0; // Assume 83 INR/USD
  double get totalValueInr => items.fold(0.0, (sum, item) {
    final currentPrice = currentPrices[item.coinId] ?? item.buyPrice;
    return sum + (item.amount * currentPrice * 83.0);
  });

  double get totalPnlInr => totalValueInr - totalInvestedInr;
  double get totalPnlPercentage => totalInvestedInr == 0 ? 0 : (totalPnlInr / totalInvestedInr) * 100;

  @override
  List<Object?> get props => [status, items, currentPrices, errorMessage];

  PortfolioState copyWith({
    PortfolioStatus? status,
    List<PortfolioItem>? items,
    Map<String, double>? currentPrices,
    String? errorMessage,
  }) {
    return PortfolioState(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPrices: currentPrices ?? this.currentPrices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
