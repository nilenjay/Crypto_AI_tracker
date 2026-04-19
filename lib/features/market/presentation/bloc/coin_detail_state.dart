import '../../data/models/coin_insight_model.dart';
import '../../data/models/coin_graph_model.dart';

abstract class CoinDetailState {}

class CoinDetailInitial extends CoinDetailState {}

class CoinDetailLoading extends CoinDetailState {}

class CoinDetailLoaded extends CoinDetailState {
  final CoinInsightModel insight;
  final CoinGraphModel graph;

  CoinDetailLoaded({
    required this.insight,
    required this.graph,
  });
}

class CoinDetailError extends CoinDetailState {
  final String message;

  CoinDetailError({required this.message});
}
