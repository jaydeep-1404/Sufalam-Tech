class CategoryModel {
  int? id;
  String name;

  CategoryModel({this.id, required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}


class ContactModel {
  int? id;
  String firstName;
  String lastName;
  String email;
  String phoneNo;
  String? imageBase64;
  int categoryId;
  String categoryName;

  ContactModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    this.imageBase64,
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNo': phoneNo,
      'imageBase64': imageBase64,
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phoneNo: map['phoneNo'],
      imageBase64: map['imageBase64'],
      categoryId: map['categoryId'],
      categoryName: map['categoryName'],
    );
  }
}