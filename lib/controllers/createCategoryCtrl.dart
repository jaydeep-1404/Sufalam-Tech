import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sufalam/src/commonWidgets/snackbars.dart';
import '../models/category.dart';
import '../utils/database.dart';

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
        AppSnackbar.success(message: "Category Created Successfully",title: "Success");
      } else {
        final old = categories[editingIndex.value!];
        await DatabaseHelper().updateCategory(CategoryModel(id: old.id, name: name));
        editingIndex.value = null;
        AppSnackbar.success(message: "Category Updated Successfully",title: "Success");
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
    AppSnackbar.delete(title: "Removed",message: "Category Deleted Successfully");
    loadCategories();
  }
}