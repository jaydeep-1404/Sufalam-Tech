import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contacts.dart';
import 'drawer.dart';

class ContactListPage extends StatefulWidget {
  ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ContactController controller = Get.put(ContactController());

  @override
  void initState() {
    // TODO: implement initState
    controller.loadContacts();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Contacts"),
      ),
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