class CoinInsightModel {
  final String coinId;
  final String insightMessage;
  final String riskLevel;
  final String recommendationAction;
  final double predictedChangePct;

  CoinInsightModel({
    required this.coinId,
    required this.insightMessage,
    required this.riskLevel,
    required this.recommendationAction,
    required this.predictedChangePct,
  });

  factory CoinInsightModel.fromJson(Map<String, dynamic> json) {
    return CoinInsightModel(
      coinId: json['coin_id'] ?? '',
      insightMessage: json['ai_insight'] ?? 'Insight unavailable.',
      riskLevel: json['risk']?['risk_level'] ?? 'UNKNOWN',
      recommendationAction: json['recommendation']?['action'] ?? 'HOLD',
      predictedChangePct: (json['prediction']?['predicted_change_pct'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
