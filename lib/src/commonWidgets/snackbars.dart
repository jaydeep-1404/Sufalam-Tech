import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void success({String title = "Success", String message = "Operation completed"}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 10,
    );
  }

  static void warning({String title = "Warning", String message = "Please check your input"}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.warning, color: Colors.white),
      backgroundColor: Colors.orangeAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 10,
    );
  }

  static void error({String title = "Error", String message = "Something went wrong"}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error, color: Colors.white),
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 10,
    );
  }

  static void delete({String title = "Deleted", String message = "Item has been removed"}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.delete, color: Colors.white),
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 10,
    );
  }

  static void show({
    required String title,
    required String message,
    Color backgroundColor = Colors.blueGrey,
    IconData icon = Icons.info,
  }) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: Colors.white),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 10,
    );
  }
}