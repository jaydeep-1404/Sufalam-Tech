import 'package:flutter/material.dart';
import 'addContact.dart';
import 'contactList.dart';
import 'createCategory.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 100,),
          ListTile(
            leading: const Icon(Icons.contact_page),
            title: const Text('Contacts'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ContactListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Contact'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => UserFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => CategoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}