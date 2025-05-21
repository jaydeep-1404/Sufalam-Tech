import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import '../controllers/createCategoryCtrl.dart';
import 'commonWidgets/common.dart';
import 'drawer.dart';

class CreateCategoryPage extends StatelessWidget {
  final vm = Get.put(CreateCategoryCtrl());

  CreateCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: const Text('Category'),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createFieldAndButton(),
          _editItemView(),
          _categories(),
        ],
      ),
    );
  }

  Widget _createFieldAndButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
    child: Form(
      key: vm.formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: vm.txtCtrl,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Category name',
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
              value == null || value.trim().isEmpty ? 'Enter name' : null,
            ),
          ),
          const SizedBox(width: 12),
          Obx(() {
            final isEditing = vm.edtIdx.value != null;
            return ElevatedButton(
              onPressed: vm.saveCat,
              child: Text(isEditing ? 'Update' : 'Add'),
            );
          }),
        ],
      ),
    ),
  );

  Widget _editItemView() => Obx(() {
    if (vm.edtIdx.value != null) {
      final selected = vm.categories[vm.edtIdx.value!];
      return Container(
        margin: const EdgeInsets.only(bottom: 8,left: 10,right: 10),
        padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Editing: ${selected.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                vm.edtIdx.value = null;
                vm.txtCtrl.clear();
              },
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  });

  Widget _categories() => Expanded(
    child: Obx(() {
      if (vm.categories.isEmpty) return const EmptyData(message: "No Category Found",);
      return ListView.builder(
        itemCount: vm.categories.length,
        itemBuilder: (_, index) {
          final category = vm.categories[index];
          return CategoryItems(
            name: category.name,
            onEdit: () => vm.updCat(index),
            onDelete: () => vm.rmCat(index),
          );
        },
      );
    }),
  );

}