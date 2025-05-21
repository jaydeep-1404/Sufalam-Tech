import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:sufalam/src/commonWidgets/common.dart';
import 'package:sufalam/src/commonWidgets/snackbars.dart';
import '../controllers/contacts.dart';
import 'addContact.dart';
import 'drawer.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final controller = Get.put(ContactController());
  final searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => isSearching.value ? TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: '  Search by name...',
              border: InputBorder.none,
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              )
          ),
          onChanged: (value) => controller.searchContacts(value),
        ) : const Text("Contacts")),
        actions: _filterSorting(),
      ),
      drawer: const CustomDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) return const DataLoader();
        if (controller.filteredContacts.isEmpty) return EmptyData(message: "No Contacts Found",);
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: controller.filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = controller.filteredContacts[index];
            final img = contact.imageBase64;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: img != null && img.isNotEmpty ?
                      MemoryImage(base64Decode(img)) :
                      const AssetImage("https://cdn-icons-png.flaticon.com/512/149/149071.png") as ImageProvider,
                    ),
                    title: Text(
                      "${contact.firstName} ${contact.lastName}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const VerticalDivider(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () => Get.to(() => CreateContactPage(contact: contact)),
                        ),
                        const VerticalDivider(),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            controller.deleteContact(contact.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          },
        );
      }),
    );
  }

  List<IconButton> _filterSorting() => [
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
  ];

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.sortByCategory(ascending: true);
                  Get.back();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_upward, color: Colors.black),
                    SizedBox(height: 8),
                    Text("Ascend"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.sortByCategory(ascending: false);
                  Get.back();
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.black),
                    SizedBox(height: 8),
                    Text("Descend"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}