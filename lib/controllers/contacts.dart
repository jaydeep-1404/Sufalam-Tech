import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart' show Debouncer;
import 'package:sufalam/src/commonWidgets/snackbars.dart';
import '../models/contacts.dart';
import '../utils/database.dart';

class ContactController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  var contacts = <ContactModel>[].obs;
  var filteredContacts = <ContactModel>[].obs;
  var loading = true.obs;

  void loadContacts() async {
    loading(true);
    final data = await _dbHelper.getContacts();
    contacts.assignAll(data);
    filteredContacts.assignAll(data);
    loading(false);
  }

  void searchContacts(String query) {
    _debouncer.call(() {
      if (query.isEmpty) {
        filteredContacts.assignAll(contacts);
      } else {
        final filtered = contacts.where((contact) {
          final name = "${contact.firstName} ${contact.lastName}".toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
        filteredContacts.assignAll(filtered);
      }
    });
  }

  void sortByCat({required bool ascending}) {
    final sorted = List<ContactModel>.from(filteredContacts);
    sorted.sort((a, b) => ascending
        ? a.categoryName.compareTo(b.categoryName)
        : b.categoryName.compareTo(a.categoryName));
    filteredContacts.assignAll(sorted);
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    AppSnackbar.delete(title: "Removed", message: "Contact Deleted Successfully");
    loadContacts();
  }

  @override
  void onClose() {
    _debouncer.cancel();
    super.onClose();
  }
}