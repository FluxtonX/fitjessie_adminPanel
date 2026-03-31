import 'package:flutter/material.dart';
import 'package:admin_panel/constants/admin_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Overview',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AdminColors.textHigh,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monitor your gym\'s performance and user engagement.',
            style: TextStyle(color: AdminColors.textLow, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _buildStatCard('Total Users', '1,284', Icons.people, AdminColors.primaryTeal),
              _buildStatCard('Active Today', '342', Icons.flash_on, AdminColors.secondaryCyan),
              _buildStatCard('Revenue', '\$12.4k', Icons.monetization_on, AdminColors.warningOrange),
              _buildStatCard('Engagement', '84%', Icons.trending_up, AdminColors.successGreen),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildActivityFeed()),
                const SizedBox(width: 24),
                Expanded(child: _buildRecentPrograms()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AdminColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 24),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: AdminColors.textLow, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              Icon(Icons.more_horiz, color: AdminColors.textLow),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, index) => _buildActivityItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      'Sarah M. joined "Fat Burn 30"',
      'John D. reached Gold League',
      'Mike R. completed Morning Yoga',
      'Emma W. subscribed to Pro Plan',
      'Alex P. earned "Early Bird" Badge',
    ];
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AdminColors.primaryTeal.withValues(alpha: 0.1),
          child: const Icon(Icons.circle, size: 8, color: AdminColors.primaryTeal),
        ),
        const SizedBox(width: 16),
        Text(activities[index], style: const TextStyle(color: AdminColors.textMedium)),
        const Spacer(),
        Text('2m ago', style: TextStyle(color: AdminColors.textLow, fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentPrograms() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Programs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          _buildProgramItem('HIIT Extreme', '452 Users', Colors.orange),
          _buildProgramItem('Yoga for Beginners', '284 Users', Colors.green),
          _buildProgramItem('Strength Training', '195 Users', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildProgramItem(String name, String users, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(width: 4, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(users, style: const TextStyle(color: AdminColors.textLow, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
