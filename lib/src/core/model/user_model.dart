import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  late String name;
  late String password;
  late String email;
  late String phone;
  late String major;
  late String userType;
  
  UserModel(
      {this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.phone,
      required this.major, 
      required this.userType
      });

  tojason() {
    return {
      "Email": email,
      "Password": password,
      "UserName": name,
      "major": major,
      "phone": phone,
      "userType" : userType
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return UserModel(
        id: documentSnapshot.id,
        email: data["Email"],
        name: data["UserName"],
        password: data["Password"],
        phone: data["phone"],
        major: data["major"], userType: data['userType']);
  }
}
