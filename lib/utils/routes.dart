
import 'package:get/get_navigation/src/routes/get_route.dart' show GetPage;
import 'package:sufalam/src/addContact.dart';
import 'package:sufalam/src/contactList.dart';
import 'package:sufalam/src/createCategory.dart';

class ConstRoute {
  static const String contacts = '/contacts',
      categoryCreate = '/categoryCreate',
      contactCreate = '/contactCreate';
}

class RoutePage {
  static const initial = ConstRoute.contacts;
  static List<GetPage> routes = [
    GetPage(name: ConstRoute.contacts, page: () => ContactListPage()),
    GetPage(name: ConstRoute.categoryCreate, page: () => CreateCategoryPage(),),
    GetPage(name: ConstRoute.contactCreate, page: () => CreateContactPage(),),
 ];
}