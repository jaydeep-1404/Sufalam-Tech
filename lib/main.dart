import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sufalam/src/contactList.dart';

void main() => runZonedGuarded(() => runApp(const MyApp()), (e, s) => log("$e, $s"),);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sufalam Tech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: ContactListPage(),
    );
  }
}
