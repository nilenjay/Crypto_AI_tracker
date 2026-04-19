import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
              _buildHeader(),
              const SizedBox(height: 24),
              _buildPortfolioCards(),
              const SizedBox(height: 28),
              _buildSectionHeader('Market Trends', 'See All'),
              const SizedBox(height: 16),
              _buildPriceList(),
              const SizedBox(height: 24),
              _buildAIInsightCard(context),
              const SizedBox(height: 80), // For bottom nav spacing
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CRYPTOAI TRACKER',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2229),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(LucideIcons.bell, size: 20),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          action,
          style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        ),
      ],
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
            'Search Bitcoin, Ethereum...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCards() {
    return Row(
      children: [
        Expanded(
          child: _buildValueCard(
            title: 'PORTFOLIO VALUE',
            value: '₹2,44,000',
            subValue: '+₹8,000 today',
            subValueColor: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildValueCard(
            title: '24H P&L',
            value: '+₹8,000',
            subValue: '+3.4% overall',
            subValueColor: Colors.greenAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard({
    required String title,
    required String value,
    required String subValue,
    required Color subValueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subValue,
            style: TextStyle(color: subValueColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketTrendCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.greenAccent.withOpacity(0.1),
            const Color(0xFF171B21),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MARKET TREND',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'BULLISH',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Global sentiment +62%',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.trending_up, color: Colors.greenAccent, size: 48),
        ],
      ),
    );
  }

  Widget _buildPriceList() {
    return Column(
      children: [
        _buildPriceItem(
          name: 'Bitcoin',
          symbol: 'BTC',
          price: '₹52.00L',
          change: '+2.5%',
          isPositive: true,
          icon: 'B',
        ),
        const SizedBox(height: 12),
        _buildPriceItem(
          name: 'Ethereum',
          symbol: 'ETH',
          price: '₹2.80L',
          change: '-1.2%',
          isPositive: false,
          icon: 'E',
        ),
        const SizedBox(height: 12),
        _buildPriceItem(
          name: 'Solana',
          symbol: 'SOL',
          price: '₹12.0K',
          change: '+5.8%',
          isPositive: true,
          icon: 'S',
        ),
      ],
    );
  }

  Widget _buildPriceItem({
    required String name,
    required String symbol,
    required String price,
    required String change,
    required bool isPositive,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF242A32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(symbol, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  Icon(
                    isPositive ? LucideIcons.arrow_up_right : LucideIcons.arrow_down_right,
                    size: 14,
                    color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  ),
                  Text(
                    change,
                    style: TextStyle(
                      color: isPositive ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21).withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🧠', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                'AI INSIGHT',
                style: TextStyle(color: Colors.blueAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"Market is slightly bullish today. BTC holding strong above key support. Consider holding..."',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

}
