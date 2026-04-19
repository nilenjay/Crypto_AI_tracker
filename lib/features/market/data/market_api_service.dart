import 'package:dio/dio.dart';
import 'models/coin_price_model.dart';

class MarketApiService {
  final Dio _dio;
  
  MarketApiService() : _dio = Dio(BaseOptions(baseUrl: 'https://yashasvi-01-02-crypto-ai-api.hf.space'));

  Future<List<String>> getSupportedCoins() async {
    try {
      final response = await _dio.get('/coins');
      final List<dynamic> coins = response.data['supported_coins'];
      return coins.cast<String>();
    } catch (e) {
      throw Exception('Failed to load supported coins: $e');
    }
  }

  Future<CoinPriceModel> getCoinPrice(String coinId) async {
    try {
      final response = await _dio.get('/price/$coinId');
      return CoinPriceModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Failed to load price for $coinId. URI: ${e.requestOptions.uri}. Error: $e');
      }
      throw Exception('Failed to load price for $coinId: $e');
    }
  }
}
