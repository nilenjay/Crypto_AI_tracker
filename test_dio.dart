import 'package:dio/dio.dart';

void main() async {
  final targetCoins = ['bitcoin', 'ethereum', 'binancecoin', 'solana', 'cardano', 'dogecoin'];
  final dio = Dio(BaseOptions(baseUrl: 'https://yashasvi-01-02-crypto-ai-api.hf.space'));
  for(var c in targetCoins) {
    try {
      final response = await dio.get('/price/$c');
      print(response.data);
    } catch (e) {
      print('Error for $c: $e');
    }
  }
}
