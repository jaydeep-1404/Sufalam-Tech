import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/addContactCtrl.dart';
import 'drawer.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  final ctrl = Get.put(UserFormController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Contact Form'),
      ),
      body: Form(
        key: ctrl.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Obx(() => GestureDetector(
                onTap: () => ctrl.showImagePickerOptions(context),
                child: CircleAvatar(
                  radius: Platform.isAndroid ? 60 : 70,
                  backgroundImage: ctrl.selectedImage.value != null
                      ? FileImage(ctrl.selectedImage.value!)
                      : const NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png')
                  as ImageProvider,
                ),
              )),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('First Name'),
                onSaved: (val) => ctrl.firstName.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter first name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Last Name'),
                onSaved: (val) => ctrl.lastName.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter last name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => ctrl.email.value = val ?? '',
                validator: (val) {
                  if (val!.isEmpty) return 'Enter Email';
                  // if (!GetUtils.isEmail(val)) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Mobile No'),
                keyboardType: TextInputType.phone,
                onSaved: (val) => ctrl.mobile.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter mobile no' : null,
              ),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Category'),
                  value: ctrl.selectedCategory.value.isEmpty
                      ? null
                      : ctrl.selectedCategory.value,
                  items: ctrl.categories.map((e) {
                    return DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name),
                      onTap: () =>
                      ctrl.selectedCategoryId.value = e.id!,
                    );
                  }).toList(),
                  onChanged: (val) =>
                  ctrl.selectedCategory.value = val!,
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Select category' : null,
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: ctrl.submitForm,
                child: const Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  );
}