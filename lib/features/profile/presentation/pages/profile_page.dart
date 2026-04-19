import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../data/profile_repository.dart';
import '../../data/profile_model.dart';
import '../profile_bloc/profile_bloc.dart';
import '../../../auth/presentation/auth_bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        profileRepository: ProfileRepository(),
      )..add(const ProfileLoadRequested()),
      child: const _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2D7CF6)),
              );
            }
            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.circle_alert, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.read<ProfileBloc>().add(const ProfileLoadRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final profile = (state as ProfileLoaded).profile;
            return _buildContent(context, profile);
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildContent(BuildContext context, UserProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildProfileCard(context, profile),
          const SizedBox(height: 28),
          _buildSectionLabel('SETTINGS'),
          const SizedBox(height: 12),
          _buildSettingsCard(context, profile),
          const SizedBox(height: 12),
          _buildLinksCard(context),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/dashboard'),
          child: const Icon(LucideIcons.arrow_left, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile profile) {
    final joinYear = profile.memberSince.year;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D7CF6), Color(0xFF00C076)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    profile.displayName.isNotEmpty
                        ? profile.displayName[0].toUpperCase()
                        : 'C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.memberType} · Active Since $joinYear',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 20),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('PORTFOLIO', profile.portfolioValue, Colors.white),
              _buildStatDivider(),
              _buildStatItem('HOLDINGS', profile.holdingsCount.toString(), Colors.white),
              _buildStatDivider(),
              _buildStatItem(
                'P&L (TOTAL)',
                profile.pnlTotal,
                profile.pnlTotal.startsWith('+')
                    ? const Color(0xFF00C076)
                    : Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 36, width: 1, color: Colors.white12);
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, UserProfile profile) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Currency
          _buildCurrencySetting(context, profile),
          _buildDivider(),
          // Theme
          _buildThemeSetting(context),
          _buildDivider(),
          // Notifications
          _buildNotificationSetting(context, profile),
        ],
      ),
    );
  }

  Widget _buildCurrencySetting(BuildContext context, UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _buildSettingIcon(LucideIcons.credit_card),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Currency',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          // Currency selector chips
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF242A32),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              children: ['₹', '\$', '€'].map((currency) {
                final isSelected = profile.currency == currency;
                return GestureDetector(
                  onTap: () => context.read<ProfileBloc>().add(
                        ProfileCurrencyChanged(currency),
                      ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF00C076) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currency,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSetting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _buildSettingIcon(LucideIcons.moon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Theme',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Row(
            children: [
              Text(
                'Dark',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF242A32),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.moon, size: 14, color: Color(0xFF00C076)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSetting(BuildContext context, UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildSettingIcon(LucideIcons.bell),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Notifications',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Switch(
            value: profile.notificationsEnabled,
            activeThumbColor: const Color(0xFF00C076),
            activeTrackColor: const Color(0xFF00C07640),
            onChanged: (value) {
              context.read<ProfileBloc>().add(ProfileNotificationsToggled(value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLinksCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171B21),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildLinkItem(context, LucideIcons.shield, 'Privacy Policy', () {}),
          _buildDivider(),
          _buildLinkItem(context, LucideIcons.file_text, 'Terms of Service', () {}),
          _buildDivider(),
          _buildLinkItem(context, LucideIcons.info, 'About', () {}),
        ],
      ),
    );
  }

  Widget _buildLinkItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            _buildSettingIcon(icon),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const Icon(LucideIcons.chevron_right, size: 16, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingIcon(IconData icon) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF242A32),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 17, color: Colors.white60),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.white10,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(LogoutRequested());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        child: const Text(
          'Log Out',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0F14),
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, LucideIcons.house, 'Home', false, '/dashboard'),
          _buildNavItem(context, LucideIcons.chart_bar_big, 'Market', false, '/dashboard'),
          _buildNavItem(context, LucideIcons.wallet, 'Portfolio', false, '/dashboard'),
          _buildNavItem(context, LucideIcons.cpu, 'AI', false, '/dashboard'),
          _buildNavItem(context, LucideIcons.user, 'Profile', true, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    String route,
  ) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF00C076) : Colors.white38,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF00C076) : Colors.white38,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
