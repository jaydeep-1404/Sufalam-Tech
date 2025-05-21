import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sufalam/controllers/contacts.dart';
import 'package:sufalam/src/commonWidgets/snackbars.dart';
import 'package:sufalam/src/contactList.dart';
import '../models/category.dart';
import '../models/contacts.dart';
import '../utils/database.dart';


class CreateContactCtrl extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  final firstName = ''.obs,
      lastName = ''.obs,
      email = ''.obs,
      mobile = ''.obs,
      selCat = ''.obs,
      selCatId = 0.obs;

  final selectedImage = Rx<File?>(null);
  final img = ''.obs;

  final categories = <CategoryModel>[].obs;

  final isEdit = false.obs;
  ContactModel? editingContact;

  void setEditingContact(ContactModel contact) {
    isEdit.value = true;
    editingContact = contact;

    firstName.value = contact.firstName;
    lastName.value = contact.lastName;
    email.value = contact.email ?? '';
    mobile.value = contact.phoneNo;
    selCat.value = contact.categoryName;
    selCatId.value = contact.categoryId;
    img.value = contact.imageBase64 ?? '';
  }

  void clearForm() {
    formKey.currentState?.reset();
    firstName.value = '';
    lastName.value = '';
    email.value = '';
    mobile.value = '';
    selCat.value = '';
    selCatId.value = 0;
    selectedImage.value = null;
    img.value = '';
    isEdit.value = false;
    editingContact = null;
  }

  Future<void> loadCats() async {
    final data = await dbHelper.getCategories();
    categories.assignAll(data);
  }

  Future<void> pickImg(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source, imageQuality: 60);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String? base64Image = img.value;
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
        categoryId: selCatId.value,
        categoryName: selCat.value,
        imageBase64: base64Image,
      );

      if (base64Image.isNotEmpty){
        if (isEdit.value && contact.id != null) {
          await dbHelper.updateContact(contact);
          AppSnackbar.success(message: "Contact Updated",title: "Success");
        } else {
          await dbHelper.addContact(contact);
          AppSnackbar.success(message: "Contact Saved",title: "Success");
        }

        clearForm();
        Get.put(ContactController()).loadContacts();
        Get.off(ContactListPage());
      } else {
        AppSnackbar.warning(message: "Select Image",title: "Warning");
      }


    }
  }
}