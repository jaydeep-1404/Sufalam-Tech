import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/sql_service.dart';
import '../models/categoryModel.dart';


class CategoryViewModel extends GetxController {
  final categories = <CategoryModel>[].obs;
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final editingIndex = RxnInt();

  @override
  void onInit() {
    loadCategories();
    super.onInit();
  }

  void loadCategories() async {
    final data = await DatabaseHelper().getCategories();
    categories.assignAll(data);
  }

  void saveCategory() async {
    if (formKey.currentState!.validate()) {
      final name = textController.text.trim();

      if (editingIndex.value == null) {
        await DatabaseHelper().insertCategory(CategoryModel(name: name));
      } else {
        final old = categories[editingIndex.value!];
        await DatabaseHelper().updateCategory(CategoryModel(id: old.id, name: name));
        editingIndex.value = null;
      }

      textController.clear();
      loadCategories();
    }
  }

  void editCategory(int index) {
    textController.text = categories[index].name;
    editingIndex.value = index;
  }

  void deleteCategory(int index) async {
    final id = categories[index].id!;
    await DatabaseHelper().deleteCategory(id);
    if (editingIndex.value == index) {
      editingIndex.value = null;
      textController.clear();
    }
    loadCategories();
  }
}