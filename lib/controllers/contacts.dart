import 'package:get/get.dart';

import '../db/sql_service.dart';
import '../models/contacts.dart';

class ContactController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  var contacts = <ContactModel>[].obs;
  var filteredContacts = <ContactModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    loadContacts();
    super.onInit();
  }

  void loadContacts() async {
    isLoading.value = true;
    final data = await _dbHelper.getContacts();
    contacts.assignAll(data);
    filteredContacts.assignAll(data);
    isLoading.value = false;
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      filteredContacts.assignAll(contacts);
    } else {
      final filtered = contacts.where((contact) {
        final name = "${contact.firstName} ${contact.lastName}".toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
      filteredContacts.assignAll(filtered);
    }
  }

  void sortByCategory({required bool ascending}) {
    final sorted = List<ContactModel>.from(filteredContacts);
    sorted.sort((a, b) => ascending
        ? a.categoryName.compareTo(b.categoryName)
        : b.categoryName.compareTo(a.categoryName));
    filteredContacts.assignAll(sorted);
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    loadContacts();
  }
}