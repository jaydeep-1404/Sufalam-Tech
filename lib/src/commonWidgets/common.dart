
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class DataLoader extends StatelessWidget {
  const DataLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class EmptyData extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  const EmptyData({
    super.key,
    this.message = "No Data Found",
    this.icon = Icons.inbox,
    this.iconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  final String name;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryItems({
    super.key,
    required this.name,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.1,
      child: ListTile(
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalDivider(indent: 10, endIndent: 10),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: onEdit,
            ),
            const VerticalDivider(indent: 10, endIndent: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}


class SortOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onAscending;
  final VoidCallback onDescending;

  const SortOptionsBottomSheet({
    super.key,
    required this.onAscending,
    required this.onDescending,
  });

  static void show({
    required VoidCallback onAscending,
    required VoidCallback onDescending,
  }) {
    Get.bottomSheet(
      SortOptionsBottomSheet(
        onAscending: onAscending,
        onDescending: onDescending,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildOption(Icons.arrow_upward, 'Ascend', onAscending),
          _buildOption(Icons.arrow_downward, 'Descend', onDescending),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
          Get.back();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

