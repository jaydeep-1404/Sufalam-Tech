
import 'package:flutter/material.dart';

class DataLoader extends StatelessWidget {
  const DataLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class EmptyData extends StatelessWidget {
  String? message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message ?? "No Data found"));
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
        title: Text(name),
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

class ContactItem extends StatelessWidget {
  const ContactItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
