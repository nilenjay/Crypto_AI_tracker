abstract class CoinDetailEvent {}

class LoadCoinDetail extends CoinDetailEvent {
  final String coinId;

  LoadCoinDetail(this.coinId);
}
