import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contacts.dart';
import 'addContact.dart';
import 'drawer.dart';

class ContactListPage extends StatefulWidget {
  ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ContactController controller = Get.put(ContactController());
  final TextEditingController searchController = TextEditingController();

  var isSearching = false.obs;

  @override
  void initState() {
    controller.loadContacts();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    controller.contacts.clear();
    controller.filteredContacts.clear();
    controller.isLoading.value = true;
    super.dispose();
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text("Sort by Category Ascending"),
              onTap: () {
                controller.sortByCategory(ascending: true);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text("Sort by Category Descending"),
              onTap: () {
                controller.sortByCategory(ascending: false);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => isSearching.value
            ? TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search by name...',
            border: InputBorder.none,
          ),
          onChanged: (value) => controller.searchContacts(value),
        )
            : const Text("Contacts")),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              isSearching.value ? Icons.close : Icons.search,
            )),
            onPressed: () {
              if (isSearching.value) {
                searchController.clear();
                controller.searchContacts('');
              }
              isSearching.toggle();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.filteredContacts.isEmpty) {
          return const Center(child: Text("No contacts found"));
        } else {
          return ListView.builder(
            itemCount: controller.filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = controller.filteredContacts[index];
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
                        Get.to(() => CreateContactPage(contact: contact));
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

