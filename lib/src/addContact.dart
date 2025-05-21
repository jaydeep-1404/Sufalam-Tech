import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart';
import 'package:sufalam/utils/consts.dart';
import '../controllers/addContactCtrl.dart';
import '../models/contacts.dart';
import 'drawer.dart';

class CreateContactPage extends StatefulWidget {
  final ContactModel? contact;

  const CreateContactPage({super.key, this.contact});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  final ctrl = Get.put(UserFormController());

  @override
  void initState() {
    super.initState();
    ctrl.loadCategories();
    if (widget.contact != null) ctrl.setEditingContact(widget.contact!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(ctrl.isEditMode.value ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Form(
        key: ctrl.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(() => GestureDetector(
                // onTap: () => ctrl.showImagePickerOptions(context),
                onTap: () => showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  builder: (_) => Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Camera'),
                        onTap: () {
                          Get.back();
                          ctrl.pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Gallery'),
                        onTap: () {
                          Get.back();
                          ctrl.pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ),
                  child: CircleAvatar(
                    radius: Platform.isAndroid ? 60 : 70,
                    backgroundImage: ctrl.selectedImage.value != null
                        ? FileImage(ctrl.selectedImage.value!)
                        : (widget.contact != null && ctrl.imageBase64.value.isNotEmpty
                        ? MemoryImage(base64Decode(ctrl.imageBase64.value))
                        : const NetworkImage(emptyProfileImg)) as ImageProvider,
                  )
              )),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('First Name'),
                style: inputStyle(),
                initialValue: ctrl.firstName.value,
                onSaved: (val) => ctrl.firstName.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter first name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Last Name'),
                initialValue: ctrl.lastName.value,
                style: inputStyle(),
                onSaved: (val) => ctrl.lastName.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter last name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Email'),
                style: inputStyle(),
                keyboardType: TextInputType.emailAddress,
                initialValue: ctrl.email.value,
                onSaved: (val) => ctrl.email.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: _inputDecoration('Phone'),
                style: inputStyle(),
                keyboardType: TextInputType.phone,
                initialValue: ctrl.mobile.value,
                onSaved: (val) => ctrl.mobile.value = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<String>(
                  decoration: _inputDecoration('Category'),
                  style: inputStyle(),
                  value: ctrl.selectedCategory.value.isEmpty ? null : ctrl.selectedCategory.value,
                  items: ctrl.categories.map((e) {
                    return DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name),
                      onTap: () => ctrl.selectedCategoryId.value = e.id!,
                    );
                  }).toList(),
                  onChanged: (val) => ctrl.selectedCategory.value = val!,
                  validator: (val) => val == null || val.isEmpty ? 'Select category' : null,
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: ctrl.submitForm,
                child: Text(ctrl.isEditMode.value ? 'Update Contact' : 'Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.grey[700],
    ),
    border: const OutlineInputBorder(),
  );

  TextStyle inputStyle() => GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

}