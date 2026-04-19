import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F14),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, LucideIcons.house, 'Home', 0, '/dashboard'),
          _buildNavItem(context, LucideIcons.chart_bar_big, 'Market', 1, '/market'),
          _buildNavItem(context, LucideIcons.wallet, 'Portfolio', 2, '/portfolio'),
          _buildNavItem(context, LucideIcons.cpu, 'AI', 3, '/ai-insights'),
          _buildNavItem(context, LucideIcons.user, 'Profile', 4, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, String route) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (!isActive && route.isNotEmpty) {
          context.go(route);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.blueAccent : Colors.white54, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.blueAccent : Colors.white54,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
