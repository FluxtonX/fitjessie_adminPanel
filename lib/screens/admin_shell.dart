import 'package:flutter/material.dart';
import 'package:admin_panel/constants/admin_colors.dart';
import 'package:admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:admin_panel/screens/users/user_management_screen.dart';
import 'package:admin_panel/screens/content/content_management_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const UserManagementScreen(),
    const ContentManagementScreen(),
    const Center(child: Text('Notifications (Coming Soon)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Container(
              color: AdminColors.backgroundBlack,
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        border: Border(
          right: BorderSide(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildLogo(),
          const SizedBox(height: 48),
          _buildNavItem(0, Icons.dashboard_rounded, 'Dashboard'),
          _buildNavItem(1, Icons.people_alt_rounded, 'Users'),
          _buildNavItem(2, Icons.video_library_rounded, 'Content'),
          _buildNavItem(3, Icons.notifications_active_rounded, 'Announcements'),
          const Spacer(),
          _buildAdminProfile(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AdminColors.premiumGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.flash_on, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        const Text(
          'FitJessie',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AdminColors.primaryTeal.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AdminColors.primaryTeal : AdminColors.textLow,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AdminColors.textHigh : AdminColors.textMedium,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: AdminColors.primaryTeal,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin User',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'FitJessie HQ',
                style: TextStyle(color: AdminColors.textLow, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
