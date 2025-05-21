import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sufalam/controllers/contacts.dart';
import 'package:sufalam/src/contactList.dart';
import '../db/sql_service.dart';
import '../models/category.dart';
import '../models/contacts.dart';


class UserFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final mobile = ''.obs;
  final selectedCategory = ''.obs;
  final selectedCategoryId = 0.obs;

  final selectedImage = Rx<File?>(null);
  final imageBase64 = ''.obs;

  final categories = <CategoryModel>[].obs;

  final isEditMode = false.obs;
  ContactModel? editingContact;

  void setEditingContact(ContactModel contact) {
    isEditMode.value = true;
    editingContact = contact;

    firstName.value = contact.firstName;
    lastName.value = contact.lastName;
    email.value = contact.email ?? '';
    mobile.value = contact.phoneNo;
    selectedCategory.value = contact.categoryName;
    selectedCategoryId.value = contact.categoryId;
    imageBase64.value = contact.imageBase64 ?? '';
  }

  void clearForm() {
    formKey.currentState?.reset();
    firstName.value = '';
    lastName.value = '';
    email.value = '';
    mobile.value = '';
    selectedCategory.value = '';
    selectedCategoryId.value = 0;
    selectedImage.value = null;
    imageBase64.value = '';
    isEditMode.value = false;
    editingContact = null;
  }

  Future<void> loadCategories() async {
    final data = await dbHelper.getCategories();
    categories.assignAll(data);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source, imageQuality: 60);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Get.back();
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Get.back();
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String? base64Image = imageBase64.value;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      final contact = ContactModel(
        id: editingContact?.id,
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        phoneNo: mobile.value,
        categoryId: selectedCategoryId.value,
        categoryName: selectedCategory.value,
        imageBase64: base64Image,
      );

      if (isEditMode.value && contact.id != null) {
        await dbHelper.updateContact(contact);
        Get.snackbar("Success", "Contact Updated");
      } else {
        await dbHelper.insertContact(contact);
        Get.snackbar("Success", "Contact Saved");
      }

      clearForm();
      Get.put(ContactController()).loadContacts();
      Get.off(ContactListPage());
    }
  }
}