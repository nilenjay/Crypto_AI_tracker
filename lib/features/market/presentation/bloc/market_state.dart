import '../../data/models/coin_price_model.dart';

abstract class MarketState {}

class MarketInitial extends MarketState {}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<CoinPriceModel> coins;

  MarketLoaded({required this.coins});
}

class MarketError extends MarketState {
  final String message;

  MarketError({required this.message});
}
