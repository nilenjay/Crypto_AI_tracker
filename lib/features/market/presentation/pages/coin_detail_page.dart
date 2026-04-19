import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'dart:math';

import '../../../../core/app_theme.dart';
import '../../data/models/coin_price_model.dart';
import '../bloc/coin_detail_bloc.dart';
import '../bloc/coin_detail_event.dart';
import '../bloc/coin_detail_state.dart';
import '../../../portfolio/data/models/portfolio_item.dart';
import '../../../portfolio/presentation/bloc/portfolio_bloc.dart';
import '../../../portfolio/presentation/bloc/portfolio_event.dart';

class CoinDetailPage extends StatefulWidget {
  final CoinPriceModel coin;

  const CoinDetailPage({super.key, required this.coin});

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  String _selectedRange = '24H';
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CoinDetailBloc>().add(LoadCoinDetail(widget.coin.coinId));
    _priceController.text = (widget.coin.priceUsd).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showAddPortfolioSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF171B21),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add to Portfolio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('AMOUNT', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
              const SizedBox(height: 24),
              const Text('BUY PRICE (USD)', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(_amountController.text);
                    final buyPrice = double.tryParse(_priceController.text);
                    
                    if (amount != null && amount > 0 && buyPrice != null && buyPrice > 0) {
                      context.read<PortfolioBloc>().add(
                        AddHoldingRequested(
                          PortfolioItem(
                            coinId: widget.coin.coinId,
                            symbol: _getTicker(widget.coin.coinId),
                            name: _getName(widget.coin.coinId),
                            amount: amount,
                            buyPrice: buyPrice,
                            buyDate: DateTime.now(),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added ${widget.coin.coinId.toUpperCase()} to portfolio'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.coin.change24hPct >= 0;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getBrandColor(widget.coin.coinId).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getInitials(widget.coin.coinId),
                  style: TextStyle(
                    color: _getBrandColor(widget.coin.coinId),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getName(widget.coin.coinId),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _getTicker(widget.coin.coinId),
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Header
              Text(
                '₹${(widget.coin.priceUsd * 83.0).toStringAsFixed(2)}', // Assuming INR approx
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    isPositive ? LucideIcons.trending_up : LucideIcons.trending_down,
                    color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${widget.coin.change24hPct.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '· 24h change',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Chart Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF171B21),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // Time range tabs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['1H', '24H', '7D', '1M'].map((range) {
                        final isSelected = _selectedRange == range;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRange = range;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              range,
                              style: TextStyle(
                                color: isSelected ? Colors.green : Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Chart Drawing
                    SizedBox(
                      height: 150,
                      child: BlocBuilder<CoinDetailBloc, CoinDetailState>(
                        builder: (context, state) {
                          if (state is CoinDetailLoading) {
                            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                          }
                          if (state is CoinDetailLoaded) {
                            List<List<double>> prices = state.graph.prices;
                            // Slice the array conceptually based on selected range
                            int takeCount = prices.length;
                            if (_selectedRange == '1H') takeCount = min(2, prices.length);
                            if (_selectedRange == '24H') takeCount = min(7, prices.length);
                            if (_selectedRange == '7D') takeCount = min(14, prices.length);
                            
                            List<double> mapped = prices.skip(prices.length - takeCount).map((e) => e[1]).toList();
                            if (mapped.isEmpty) mapped = [1.0, 1.0];

                            return CustomPaint(
                              size: const Size(double.infinity, 150),
                              painter: DetailChartPainter(
                                data: mapped,
                                lineColor: isPositive ? AppTheme.successColor : AppTheme.errorColor,
                              ),
                            );
                          }
                          return const Center(child: Text('Failed to load chart.'));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard('MARKET CAP', '1.02 Cr')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('VOLUME 24H', '42,000 Cr')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('HIGH 24H', '₹53.30L')),
                ],
              ),
              const SizedBox(height: 20),

              // AI Prediction Container
              BlocBuilder<CoinDetailBloc, CoinDetailState>(
                builder: (context, state) {
                  if (state is CoinDetailLoading) {
                     return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                  }
                  if (state is CoinDetailLoaded) {
                    final insight = state.insight;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171B21),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.blue.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🤖'),
                              const SizedBox(width: 8),
                              Text(
                                'AI PREDICTION',
                                style: TextStyle(
                                  color: Colors.blue.shade300,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '"${insight.insightMessage}"',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildTag(insight.recommendationAction, Colors.yellow.shade700),
                              const SizedBox(width: 12),
                              _buildTag('${insight.riskLevel} Risk', Colors.orange.shade700),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),

              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showAddPortfolioSheet,
                      icon: const Icon(LucideIcons.plus, color: Colors.green),
                      label: const Text('Add to Portfolio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.star, color: Colors.amber),
                      label: const Text('Watchlist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.withOpacity(0.05),
                        foregroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.amber.withOpacity(0.2)),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helpers for Mock mapping
  Color _getBrandColor(String coinId) {
    switch (coinId) {
      case 'bitcoin': return Colors.orangeAccent;
      case 'ethereum': return Colors.blueAccent;
      case 'binancecoin': return Colors.amber;
      case 'solana': return Colors.greenAccent;
      case 'cardano': return Colors.blue;
      default: return Colors.purpleAccent;
    }
  }

  String _getInitials(String coinId) {
    switch (coinId) {
      case 'bitcoin': return 'B';
      case 'ethereum': return 'Ξ';
      case 'binancecoin': return 'B';
      case 'solana': return 'S';
      case 'cardano': return 'A';
      default: return coinId[0].toUpperCase();
    }
  }

  String _getName(String coinId) {
    switch (coinId) {
      case 'bitcoin': return 'Bitcoin';
      case 'ethereum': return 'Ethereum';
      case 'binancecoin': return 'BNB';
      case 'solana': return 'Solana';
      case 'cardano': return 'Cardano';
      default: return coinId.toUpperCase();
    }
  }

  String _getTicker(String coinId) {
    switch (coinId) {
      case 'bitcoin': return 'BTC';
      case 'ethereum': return 'ETH';
      case 'binancecoin': return 'BNB';
      case 'solana': return 'SOL';
      case 'cardano': return 'ADA';
      default: return coinId.substring(0, min(3, coinId.length)).toUpperCase();
    }
  }
}

class DetailChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;

  DetailChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double minVal = data.reduce(min);
    final double maxVal = data.reduce(max);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final double stepX = size.width / (data.length > 1 ? data.length - 1 : 1);

    final Path path = Path();
    for (int i = 0; i < data.length; i++) {
      final double normalizedY = 1 - ((data[i] - minVal) / range);
      // Give a little padding top and bottom (e.g. 20%)
      final double y = size.height * 0.2 + (normalizedY * size.height * 0.6);
      final double x = i * stepX;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // smooth curve
        final double prevX = (i - 1) * stepX;
        final double prevNormalizedY = 1 - ((data[i - 1] - minVal) / range);
        final double prevY = size.height * 0.2 + (prevNormalizedY * size.height * 0.6);
        final double controlX1 = prevX + (x - prevX) / 2;
        path.cubicTo(controlX1, prevY, controlX1, y, x, y);
      }
    }

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    // Gradient fill below
    final Path fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withOpacity(0.3),
          lineColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
