import 'package:flutter/material.dart';
import 'package:sufalam/utils/routes.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Add Category'),
            onTap: () => Get.offAllNamed(ConstRoute.categoryCreate),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Add Contacts'),
            onTap: () => Get.offAllNamed(ConstRoute.contactCreate),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contact List'),
            onTap: () => Get.offAllNamed(ConstRoute.contacts),
          ),
          const Divider(),
        ],
      ),
    );
  }
}