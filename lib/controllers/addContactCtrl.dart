import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../db/sql_service.dart';
import '../models/categoryModel.dart';


class UserFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstName = ''.obs;
  final lastName = ''.obs;
  final mobile = ''.obs;
  final email = ''.obs;
  final selectedCategory = ''.obs;
  final selectedCategoryId = 0.obs;

  final Rx<File?> selectedImage = Rx<File?>(null);
  final demoImageUrl = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  final categories = <CategoryModel>[].obs;
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture from Camera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Select from Gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void clearImage() => selectedImage.value = null;

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String? imageBase64;
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final contact = ContactModel(
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        phoneNo: mobile.value,
        imageBase64: imageBase64,
        categoryId: selectedCategoryId.value,
        categoryName: selectedCategory.value,
      );

      await dbHelper.insertContact(contact);

      Get.snackbar(
        'Success',
        'Contact Saved Successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black,
      );

      formKey.currentState!.reset();
      selectedImage.value = null;
      selectedCategory.value = '';
      selectedCategoryId.value = 0;
    }
  }
}