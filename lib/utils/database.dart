import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/contacts.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  static const String categoryTable = 'category';
  static const String contactTable = 'contacts';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        /// Category table
        await db.execute('''
          CREATE TABLE $categoryTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        /// Contact table
        await db.execute('''
          CREATE TABLE $contactTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT NOT NULL,
            lastName TEXT NOT NULL,
            email TEXT,
            phoneNo TEXT NOT NULL,
            imageBase64 TEXT,
            categoryId INTEGER NOT NULL,
            categoryName TEXT NOT NULL,
            FOREIGN KEY (categoryId) REFERENCES $categoryTable (id)
          )
        ''');
      },
    );
  }

 /// Category
  Future<int> addCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert(categoryTable, category.toMap());
  }

  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final result = await db.query(categoryTable);
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await database;
    return await db.update(
      categoryTable,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      categoryTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  /// Contacts
  Future<int> addContact(ContactModel contact) async {
    final db = await database;
    return await db.insert(contactTable, contact.toMap());
  }

  Future<List<ContactModel>> getContacts() async {
    final db = await database;
    final result = await db.query(contactTable);
    return result.map((e) => ContactModel.fromMap(e)).toList();
  }

  Future<int> updateContact(ContactModel contact) async {
    final db = await database;
    return await db.update(
      contactTable,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      contactTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}