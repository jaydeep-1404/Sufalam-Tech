import 'package:flutter/material.dart';
import 'addContact.dart';
import 'contactList.dart';
import 'createCategory.dart';
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
            onTap: () => Get.to(() => CreateCategoryPage()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Add Contacts'),
            onTap: () => Get.to(() => CreateContactPage()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('Contact List'),
            onTap: () => Get.to(() => ContactListPage()),
          ),
          const Divider(),
        ],
      ),
    );
  }
}