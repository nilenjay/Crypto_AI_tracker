import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/custom_bottom_nav.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_state.dart';
import '../bloc/portfolio_event.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, state) {
            if (state.status == PortfolioStatus.loading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Portfolio',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryCard(context, state),
                  const SizedBox(height: 28),
                  _buildAssetDistribution(context, state),
                  const SizedBox(height: 32),
                  const Text(
                    'HOLDINGS',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.items.isEmpty)
                    _buildEmptyState()
                  else
                    ...state.items.map((item) {
                      final currentPrice = state.currentPrices[item.coinId] ?? item.buyPrice;
                      return _buildHoldingItem(context, item, currentPrice);
                    }).toList(),
                  const SizedBox(height: 100), // Spacing for bottom nav
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildSummaryCard(BuildContext context, PortfolioState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00C076).withOpacity(0.1),
            const Color(0xFF171B21),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL VALUE',
            style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatCompactCurrency(state.totalValueInr),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('INVESTED', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(_formatCompactCurrency(state.totalInvestedInr), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROFIT / LOSS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${state.totalPnlInr >= 0 ? '+' : ''}${_formatCompactCurrency(state.totalPnlInr)} (${state.totalPnlPercentage.toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: state.totalPnlInr >= 0 ? const Color(0xFF00C076) : Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetDistribution(BuildContext context, PortfolioState state) {
    if (state.items.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASSET DISTRIBUTION',
            style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Flexible(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: state.items.map((item) {
                        final currentPrice = state.currentPrices[item.coinId] ?? item.buyPrice;
                        final value = item.amount * currentPrice;
                        final totalValue = state.items.fold(0.0, (sum, i) => sum + (i.amount * (state.currentPrices[i.coinId] ?? i.buyPrice)));
                        final percentage = totalValue == 0 ? 0.0 : (value / totalValue) * 100;
                        
                        return PieChartSectionData(
                          color: _getCoinColor(item.coinId),
                          value: percentage,
                          title: '',
                          radius: 12,
                          badgeWidget: null,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 6,
                child: Column(
                  children: state.items.take(3).map((item) {
                    final currentPrice = state.currentPrices[item.coinId] ?? item.buyPrice;
                    final valueInr = item.amount * currentPrice * 83.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: BoxDecoration(color: _getCoinColor(item.coinId), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Text(item.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          const Spacer(),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(_formatCompactCurrency(valueInr), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingItem(BuildContext context, dynamic item, double currentPrice) {
    final valueInr = item.amount * currentPrice * 83.0;
    final pnlInr = (currentPrice - item.buyPrice) * item.amount * 83.0;
    final isPositive = pnlInr >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: _getCoinColor(item.coinId).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(_getCoinIcon(item.coinId), color: _getCoinColor(item.coinId), size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('${item.symbol} — ${item.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 4),
                Text('Avg buy: ${_formatCompactCurrency(item.buyPrice * 83.0)}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(_formatCompactCurrency(valueInr), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${isPositive ? '+' : ''}${_formatCompactCurrency(pnlInr)}',
                    style: TextStyle(
                      color: isPositive ? const Color(0xFF00C076) : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(LucideIcons.wallet, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text('Your portfolio is empty', style: TextStyle(color: Colors.white38, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Add coins from the Market screen to track them here', style: TextStyle(color: Colors.white24, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  String _formatCompactCurrency(double value) {
    if (value.abs() >= 10000000) { // 1 Crore = 1,00,00,000
      return '₹${(value / 10000000).toStringAsFixed(2)} Cr';
    } else if (value.abs() >= 100000) { // 1 Lakh = 1,00,000
      return '₹${(value / 100000).toStringAsFixed(2)} L';
    } else if (value.abs() >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(value);
    }
  }

  Color _getCoinColor(String coinId) {
    switch (coinId) {
      case 'bitcoin': return Colors.orangeAccent;
      case 'ethereum': return Colors.blueAccent;
      case 'binancecoin': return Colors.amber;
      case 'solana': return Colors.tealAccent;
      default: return Colors.purpleAccent;
    }
  }

  IconData _getCoinIcon(String coinId) {
    switch (coinId) {
      case 'bitcoin': return LucideIcons.bitcoin;
      case 'ethereum': return LucideIcons.coins;
      default: return LucideIcons.circle_dot;
    }
  }
}
