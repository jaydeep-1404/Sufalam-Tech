import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/createCategoryCtrl.dart';
import 'drawer.dart';

class CategoryPage extends StatelessWidget {
  final vm = Get.put(CategoryViewModel());

  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Category Category'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: vm.formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: vm.textController,
                      decoration: const InputDecoration(
                        labelText: 'Category name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Enter name' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    final isEditing = vm.editingIndex.value != null;
                    return ElevatedButton(
                      onPressed: vm.saveCategory,
                      child: Text(isEditing ? 'Update' : 'Add'),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (vm.editingIndex.value != null) {
                final selected = vm.categories[vm.editingIndex.value!];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
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
                          vm.editingIndex.value = null;
                          vm.textController.clear();
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (vm.categories.isEmpty) {
                  return const Center(child: Text('No categories'));
                }
                return ListView.builder(
                  itemCount: vm.categories.length,
                  itemBuilder: (context, index) {
                    final category = vm.categories[index];
                    final isSelected = vm.editingIndex.value == index;

                    return Card(
                      child: ListTile(
                        title: Text(category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const VerticalDivider(indent: 10,endIndent: 10,),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => vm.editCategory(index),
                            ),
                            const VerticalDivider(indent: 10,endIndent: 10,),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => vm.deleteCategory(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}