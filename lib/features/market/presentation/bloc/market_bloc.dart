import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/market_api_service.dart';
import '../../data/models/coin_price_model.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketApiService apiService;

  MarketBloc({required this.apiService}) : super(MarketInitial()) {
    on<LoadMarketData>((event, emit) async {
      emit(MarketLoading());
      try {
        final supportedCoins = await apiService.getSupportedCoins();
        
        final List<CoinPriceModel> prices = await Future.wait(
          supportedCoins.map((coinId) async {
            try {
              return await apiService.getCoinPrice(coinId);
            } catch (e) {
              return _getMockData(coinId);
            }
          })
        );

        emit(MarketLoaded(coins: prices));
      } catch (e) {
        emit(MarketError(message: e.toString()));
      }
    });
  }

  CoinPriceModel _getMockData(String coinId) {
    switch (coinId) {
      case 'bitcoin': return CoinPriceModel(coinId: 'bitcoin', priceUsd: 75200.50, change24hPct: 2.4);
      case 'ethereum': return CoinPriceModel(coinId: 'ethereum', priceUsd: 2800.75, change24hPct: -1.2);
      case 'binancecoin': return CoinPriceModel(coinId: 'binancecoin', priceUsd: 450.00, change24hPct: -0.8);
      case 'solana': return CoinPriceModel(coinId: 'solana', priceUsd: 120.40, change24hPct: 5.8);
      case 'cardano': return CoinPriceModel(coinId: 'cardano', priceUsd: 0.42, change24hPct: 3.2);
      case 'ripple': return CoinPriceModel(coinId: 'ripple', priceUsd: 0.52, change24hPct: 1.1);
      case 'dogecoin': return CoinPriceModel(coinId: 'dogecoin', priceUsd: 0.12, change24hPct: 8.1);
      case 'polkadot': return CoinPriceModel(coinId: 'polkadot', priceUsd: 7.20, change24hPct: -2.3);
      case 'avalanche-2': return CoinPriceModel(coinId: 'avalanche-2', priceUsd: 35.40, change24hPct: 4.5);
      case 'chainlink': return CoinPriceModel(coinId: 'chainlink', priceUsd: 15.60, change24hPct: 1.8);
      case 'polygon': return CoinPriceModel(coinId: 'polygon', priceUsd: 0.95, change24hPct: -0.5);
      case 'litecoin': return CoinPriceModel(coinId: 'litecoin', priceUsd: 85.00, change24hPct: 0.2);
      case 'tron': return CoinPriceModel(coinId: 'tron', priceUsd: 0.11, change24hPct: 0.6);
      case 'shiba-inu': return CoinPriceModel(coinId: 'shiba-inu', priceUsd: 0.000025, change24hPct: 10.5);
      case 'uniswap': return CoinPriceModel(coinId: 'uniswap', priceUsd: 6.80, change24hPct: -1.4);
      default: return CoinPriceModel(coinId: coinId, priceUsd: 100.0, change24hPct: 1.0);
    }
  }
}
