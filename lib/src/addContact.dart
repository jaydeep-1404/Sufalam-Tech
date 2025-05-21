import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:image_picker/image_picker.dart';
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
              _selectImage(),
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
                      child: Text(e.name,style: TextStyle(color: Colors.black),),
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

  Widget _selectImage() => Obx(() => GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _imageOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () {
                  Get.back();
                  ctrl.pickImage(ImageSource.camera);
                },
              ),
              _imageOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Get.back();
                  ctrl.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
      child: CircleAvatar(
        radius: Platform.isAndroid ? 60 : 70,
        backgroundImage: ctrl.selectedImage.value != null
            ? FileImage(ctrl.selectedImage.value!)
            : (widget.contact != null && ctrl.imageBase64.value.isNotEmpty
            ? MemoryImage(base64Decode(ctrl.imageBase64.value))
            : const NetworkImage("https://cdn-icons-png.flaticon.com/512/149/149071.png")) as ImageProvider,
      )
  ));

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(
      fontSize: 16,
    ),
    border: const OutlineInputBorder(),
  );

  TextStyle inputStyle() => GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}