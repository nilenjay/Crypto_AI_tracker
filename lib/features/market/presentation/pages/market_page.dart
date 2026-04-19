import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../../data/models/coin_price_model.dart';
import '../bloc/market_bloc.dart';
import '../bloc/market_event.dart';
import '../bloc/market_state.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();
    context.read<MarketBloc>().add(LoadMarketData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                'Market',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFilterChips(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<MarketBloc, MarketState>(
                builder: (context, state) {
                  if (state is MarketLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                  } else if (state is MarketLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<MarketBloc>().add(LoadMarketData());
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8).copyWith(bottom: 24),
                        itemCount: state.coins.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final coin = state.coins[index];
                          return _buildCryptoCard(coin);
                        },
                      ),
                    );
                  } else if (state is MarketError) {
                    return Center(
                      child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.search, color: Colors.white54, size: 20),
          SizedBox(width: 12),
          Text(
            'Search crypto...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        _buildChip('All', isSelected: true),
        const SizedBox(width: 8),
        _buildChip('Gainers', icon: LucideIcons.trending_up, iconColor: Colors.redAccent),
        const SizedBox(width: 8),
        _buildChip('Losers', icon: LucideIcons.trending_down, iconColor: Colors.blueAccent),
      ],
    );
  }

  Widget _buildChip(String label, {bool isSelected = false, IconData? icon, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF152238) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blueAccent.withOpacity(0.5) : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoCard(CoinPriceModel coin) {
    bool isPositive = coin.change24hPct >= 0;
    
    // Map colors and initials manually for demonstration
    final config = _getCoinConfig(coin.coinId);

    // Format price simply
    String formattedPrice = '';
    if (coin.priceUsd > 1000) {
      formattedPrice = '₹${(coin.priceUsd / 1000).toStringAsFixed(1)}K'; // Simplification for aesthetic
    } else {
      formattedPrice = '₹${coin.priceUsd.toStringAsFixed(2)}';
    }

    String formattedChange = '${isPositive ? '+' : ''}${coin.change24hPct.toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: config.color.withOpacity(0.3), width: 1.5),
              color: config.color.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                config.initial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: config.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  config.symbol,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 30,
              child: CustomPaint(
                painter: SparklinePainter(isPositive: isPositive),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedPrice,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      isPositive ? LucideIcons.trending_up : LucideIcons.trending_down,
                      size: 14,
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedChange,
                      style: TextStyle(
                        color: isPositive ? Colors.greenAccent : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CoinConfig _getCoinConfig(String coinId) {
    switch (coinId) {
      case 'bitcoin': return _CoinConfig('Bitcoin', 'BTC', 'B', Colors.orangeAccent);
      case 'ethereum': return _CoinConfig('Ethereum', 'ETH', 'Ξ', Colors.blueAccent);
      case 'binancecoin': return _CoinConfig('BNB', 'BNB', 'B', Colors.amber);
      case 'solana': return _CoinConfig('Solana', 'SOL', 'S', Colors.greenAccent);
      case 'cardano': return _CoinConfig('Cardano', 'ADA', 'A', Colors.blue);
      case 'ripple': return _CoinConfig('Ripple', 'XRP', 'X', Colors.blueGrey);
      case 'dogecoin': return _CoinConfig('Dogecoin', 'DOGE', 'Ð', Colors.yellow);
      case 'polkadot': return _CoinConfig('Polkadot', 'DOT', 'P', Colors.pinkAccent);
      case 'avalanche-2': return _CoinConfig('Avalanche', 'AVAX', 'A', Colors.redAccent);
      case 'chainlink': return _CoinConfig('Chainlink', 'LINK', 'L', Colors.blueAccent);
      case 'polygon': return _CoinConfig('Polygon', 'MATIC', 'M', Colors.deepPurpleAccent);
      case 'litecoin': return _CoinConfig('Litecoin', 'LTC', 'L', Colors.grey);
      case 'tron': return _CoinConfig('Tron', 'TRX', 'T', Colors.red);
      case 'shiba-inu': return _CoinConfig('Shiba Inu', 'SHIB', 'S', Colors.deepOrangeAccent);
      case 'uniswap': return _CoinConfig('Uniswap', 'UNI', 'U', Colors.pink);
      default: return _CoinConfig(coinId.toUpperCase(), coinId.toUpperCase().substring(0, min(3, coinId.length)), coinId[0].toUpperCase(), Colors.purpleAccent);
    }
  }
}

class _CoinConfig {
  final String name;
  final String symbol;
  final String initial;
  final Color color;
  _CoinConfig(this.name, this.symbol, this.initial, this.color);
}

class SparklinePainter extends CustomPainter {
  final bool isPositive;

  SparklinePainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? Colors.greenAccent : Colors.redAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Create a generic squiggly line 
    path.moveTo(0, size.height / 2);
    
    double step = size.width / 5;
    if (isPositive) {
      path.quadraticBezierTo(step * 1, size.height, step * 2.5, size.height / 2);
      path.quadraticBezierTo(step * 4, 0, size.width, size.height / 3);
    } else {
      path.quadraticBezierTo(step * 1, 0, step * 2.5, size.height / 2);
      path.quadraticBezierTo(step * 4, size.height, size.width, size.height * 0.7);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
