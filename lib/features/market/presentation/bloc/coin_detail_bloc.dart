import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/market_api_service.dart';
import '../../data/models/coin_insight_model.dart';
import '../../data/models/coin_graph_model.dart';
import 'coin_detail_event.dart';
import 'coin_detail_state.dart';

class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  final MarketApiService apiService;

  CoinDetailBloc({required this.apiService}) : super(CoinDetailInitial()) {
    on<LoadCoinDetail>((event, emit) async {
      emit(CoinDetailLoading());
      try {
        final responses = await Future.wait([
          _fetchInsightSafely(event.coinId),
          _fetchGraphSafely(event.coinId),
        ]);

        emit(CoinDetailLoaded(
          insight: responses[0] as CoinInsightModel,
          graph: responses[1] as CoinGraphModel,
        ));
      } catch (e) {
        emit(CoinDetailError(message: e.toString()));
      }
    });
  }

  Future<CoinInsightModel> _fetchInsightSafely(String coinId) async {
    try {
      return await apiService.getInsights(coinId);
    } catch (e) {
      print('Failed to get real insights for $coinId. Using mock.');
      return CoinInsightModel(
        coinId: coinId,
        insightMessage: '"Price may increase 4-6% in next 24h based on volume trends." (Mock)',
        riskLevel: 'LOW',
        recommendationAction: 'HOLD',
        predictedChangePct: 3.5,
      );
    }
  }

  Future<CoinGraphModel> _fetchGraphSafely(String coinId) async {
    try {
      return await apiService.getGraphData(coinId, days: 30);
    } catch (e) {
      print('Failed to get real graph for $coinId. Using mock.');
      // Create a mock wavy line
      List<List<double>> mockPrices = [];
      final now = DateTime.now().millisecondsSinceEpoch;
      double currentPrice = 50000;
      for (int i = 0; i < 30; i++) {
        mockPrices.add([
          (now - (30 - i) * 86400000).toDouble(),
          currentPrice + (i % 5 == 0 ? 3000 : (i % 2 == 0 ? -1000 : 2000)),
        ]);
      }
      return CoinGraphModel(
        coinId: coinId,
        prices: mockPrices,
      );
    }
  }
}
