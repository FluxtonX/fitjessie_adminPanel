import 'package:flutter/material.dart';
import 'package:admin_panel/constants/admin_colors.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildFilters(),
          const SizedBox(height: 24),
          Expanded(child: _buildUserTable()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Management', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Manage and monitor your community members', style: TextStyle(color: AdminColors.textLow)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add New User'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.primaryTeal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              hintStyle: const TextStyle(color: AdminColors.textLow),
              prefixIcon: const Icon(Icons.search, color: AdminColors.textLow),
              filled: true,
              fillColor: AdminColors.surfaceDark,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildIconButton(Icons.filter_list_rounded),
        const SizedBox(width: 8),
        _buildIconButton(Icons.file_download_rounded),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
      ),
      child: Icon(icon, color: AdminColors.textMedium),
    );
  }

  Widget _buildUserTable() {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AdminColors.surfaceLight.withValues(alpha: 0.5)),
      ),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 60,
          dataRowMinHeight: 70,
          dataRowMaxHeight: 70,
          columns: const [
            DataColumn(label: Text('USER', style: TextStyle(color: AdminColors.textLow))),
            DataColumn(label: Text('STATUS', style: TextStyle(color: AdminColors.textLow))),
            DataColumn(label: Text('ROLE', style: TextStyle(color: AdminColors.textLow))),
            DataColumn(label: Text('JOINED', style: TextStyle(color: AdminColors.textLow))),
            DataColumn(label: Text('ACTIONS', style: TextStyle(color: AdminColors.textLow))),
          ],
          rows: List.generate(8, (index) => _buildDataRow(index)),
        ),
      ),
    );
  }

  DataRow _buildDataRow(int index) {
    final users = ['Sarah Miller', 'John Doe', 'Mike Ross', 'Emma Watson', 'Alex Paris', 'Jessica Biel', 'Tom Hardy', 'Ryan Reynolds'];
    final emails = ['sarah@fit.com', 'john@fit.com', 'mike@fit.com', 'emma@fit.com', 'alex@fit.com', 'jess@fit.com', 'tom@fit.com', 'ryan@fit.com'];
    
    return DataRow(
      cells: [
        DataCell(Row(
          children: [
            CircleAvatar(radius: 18, backgroundColor: AdminColors.primaryTeal.withValues(alpha: 0.2), child: Text(users[index][0], style: const TextStyle(color: AdminColors.primaryTeal))),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(users[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(emails[index], style: const TextStyle(color: AdminColors.textLow, fontSize: 12)),
              ],
            ),
          ],
        )),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AdminColors.successGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('Active', style: TextStyle(color: AdminColors.successGreen, fontSize: 12)),
        )),
        DataCell(const Text('Subscriber', style: TextStyle(color: AdminColors.textMedium))),
        DataCell(const Text('Oct 12, 2023', style: TextStyle(color: AdminColors.textMedium))),
        DataCell(Row(
          children: [
            IconButton(icon: const Icon(Icons.edit_rounded, color: AdminColors.textLow, size: 20), onPressed: () {}),
            IconButton(icon: Icon(Icons.delete_rounded, color: AdminColors.errorRed.withValues(alpha: 0.5), size: 20), onPressed: () {}),
          ],
        )),
      ],
    );
  }
}
