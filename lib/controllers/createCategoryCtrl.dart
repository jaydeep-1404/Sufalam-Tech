import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sufalam/src/commonWidgets/snackbars.dart';
import '../models/category.dart';
import '../utils/database.dart';

class CreateCategoryCtrl extends GetxController {
  final categories = <CategoryModel>[].obs;
  final txtCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final edtIdx = RxnInt();

  @override
  void onInit() {
    getCats();
    super.onInit();
  }

  void getCats() async {
    final data = await DatabaseHelper().getCategories();
    categories.assignAll(data);
  }

  void saveCat() async {
    if (formKey.currentState!.validate()) {
      final name = txtCtrl.text.trim();

      if (edtIdx.value == null) {
        await DatabaseHelper().addCategory(CategoryModel(name: name));
        AppSnackbar.success(message: "Category Created Successfully",title: "Success");
      } else {
        final old = categories[edtIdx.value!];
        await DatabaseHelper().updateCategory(CategoryModel(id: old.id, name: name));
        edtIdx.value = null;
        AppSnackbar.success(message: "Category Updated Successfully",title: "Success");
      }

      txtCtrl.clear();
      getCats();
    }
  }

  void updCat(int index) {
    txtCtrl.text = categories[index].name;
    edtIdx.value = index;
  }

  void rmCat(int index) async {
    final id = categories[index].id!;
    await DatabaseHelper().deleteCategory(id);
    if (edtIdx.value == index) {
      edtIdx.value = null;
      txtCtrl.clear();
    }
    AppSnackbar.delete(title: "Removed",message: "Category Deleted Successfully");
    getCats();
  }
}