import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sufalam/models/contacts.dart' show ContactModel;
import '../controllers/contacts.dart';
import '../db/sql_service.dart';
import 'drawer.dart';

class ContactListPage extends StatelessWidget {
  ContactListPage({super.key});

  final ContactController controller = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts")),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.contacts.isEmpty) {
          return const Center(child: Text("No contacts found"));
        } else {
          return ListView.builder(
            itemCount: controller.contacts.length,
            itemBuilder: (context, index) {
              final contact = controller.contacts[index];
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
                      onPressed: () => controller.deleteContact(contact.id!),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}