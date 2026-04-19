import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class AiInsightsPage extends StatelessWidget {
  const AiInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildRiskAnalysisSection(context),
              const SizedBox(height: 32),
              _buildTrendPredictionSection(context),
              const SizedBox(height: 32),
              _buildSentimentSection(context),
              const SizedBox(height: 32),
              _buildRecommendationsSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Insights',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Powered by market intelligence engine',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white54,
              ),
        ),
      ],
    );
  }

  Widget _buildRiskAnalysisSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RISK ANALYSIS',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildRiskCard(LucideIcons.bitcoin, 'BTC', Colors.orange, ['High', 'Hold']),
            _buildRiskCard(LucideIcons.coins, 'ETH', Colors.blue, ['Medium', 'Buy']),
            _buildRiskCard(LucideIcons.circle_dot, 'SOL', Colors.tealAccent, ['High', 'Buy']),
            _buildRiskCard(LucideIcons.component, 'BNB', Colors.yellow, ['Low', 'Hold']),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskCard(IconData icon, String symbol, Color iconColor, List<String> tags) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            children: tags.map((tag) {
              final isRed = tag == 'High';
              final isGreen = tag == 'Buy';
              final isYellow = tag == 'Medium' || tag == 'Hold';
              final color = isRed 
                  ? Colors.redAccent 
                  : isGreen 
                      ? const Color(0xFF00C076) 
                      : Colors.orangeAccent;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendPredictionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTFOLIO TREND PREDICTION',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Actual (solid) · Predicted (dashed)',
            style: TextStyle(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value % 2 != 0) return const SizedBox();
                        return Text(
                          'D${value.toInt()}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual Data
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2, 4.5),
                      FlSpot(4, 5),
                      FlSpot(6, 4.8),
                      FlSpot(7, 4.2),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2D7CF6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2D7CF6).withValues(alpha: 0.2),
                          const Color(0xFF2D7CF6).withValues(alpha: 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Predicted Data
                  LineChartBarData(
                    spots: const [
                      FlSpot(7, 4.2),
                      FlSpot(9, 4.5),
                      FlSpot(11, 5.2),
                      FlSpot(13, 5.8),
                      FlSpot(14, 6.5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF2D7CF6),
                    barWidth: 3,
                    dashArray: [5, 5],
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                minX: 0,
                maxX: 14,
                minY: 0,
                maxY: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NEWS SENTIMENT',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF171B21),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildSentimentItem('BTC', 'Positive (75%)', 0.75, const Color(0xFF00C076)),
              const SizedBox(height: 20),
              _buildSentimentItem('ETH', 'Neutral (55%)', 0.55, Colors.orangeAccent),
              const SizedBox(height: 20),
              _buildSentimentItem('SOL', 'Positive (68%)', 0.68, const Color(0xFF00C076)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentimentItem(String symbol, String text, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              symbol,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SMART RECOMMENDATIONS',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildRecommendationItem(LucideIcons.bitcoin, 'BTC', 'Hold', Colors.orange),
        _buildRecommendationItem(LucideIcons.coins, 'ETH', 'Buy', Colors.blue),
        _buildRecommendationItem(LucideIcons.circle_dot, 'SOL', 'Buy', Colors.tealAccent),
        _buildRecommendationItem(LucideIcons.component, 'BNB', 'Hold', Colors.yellow),
      ],
    );
  }

  Widget _buildRecommendationItem(IconData icon, String symbol, String action, Color iconColor) {
    final isBuy = action == 'Buy';
    final actionColor = isBuy ? const Color(0xFF00C076) : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                  'AI Recommendation',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: actionColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              action,
              style: TextStyle(
                color: actionColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
