
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
    GetPage(name: ConstRoute.contacts, transitionDuration: Duration(milliseconds: 100), page: () => ContactListPage()),
    GetPage(name: ConstRoute.categoryCreate, transitionDuration: Duration(milliseconds: 100), page: () => CreateCategoryPage(),),
    GetPage(name: ConstRoute.contactCreate, transitionDuration: Duration(milliseconds: 100), page: () => CreateContactPage(),),
 ];
}