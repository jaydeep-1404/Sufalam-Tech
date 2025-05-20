import 'package:get/get.dart';

import '../db/sql_service.dart';
import '../models/contacts.dart';

class ContactController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  var contacts = <ContactModel>[].obs;
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
    isLoading.value = false;
  }

  Future<void> deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    loadContacts();
  }
}