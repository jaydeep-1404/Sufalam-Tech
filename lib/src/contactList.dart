import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sufalam/models/contacts.dart' show ContactModel;

import '../db/sql_service.dart';
import 'drawer.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final data = await _dbHelper.getContacts();
    setState(() => contacts = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      drawer: const CustomDrawer(),
      body: contacts.isEmpty
          ? const Center(child: Text("No contacts found"))
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final img = contact.imageBase64;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: img != null && img.isNotEmpty
                  ? MemoryImage(base64Decode(img))
                  : const AssetImage('assets/default_user.png')
              as ImageProvider,
            ),
            title: Text("${contact.firstName} ${contact.lastName}"),
            subtitle: Text("${contact.phoneNo} • ${contact.categoryName}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // TODO: Edit contact
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _dbHelper.deleteContact(contact.id!);
                    loadContacts();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}