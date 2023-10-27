import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String nokk;
  final String phone;
  final String role;
  final bool getqurban;
  final bool verifByAdmin;

  UserModel(
      {this.id,
      required this.name,
      required this.nokk,
      required this.phone,
      required this.role,
      required this.getqurban,
      required this.verifByAdmin});

  toJson() {
    return {"wali": name, "no_kk": nokk, "phone": phone, "role": role, "getqurban": getqurban, "verifByAdmin" : verifByAdmin};
  }

 factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
  final data = document.data();
  if (data == null) {
    throw StateError('Document data is null');
  }

  final id = document.id;
  final name = data['wali'] ?? '';
  final nokk = data['no_kk'] ?? '';
  final phone = data['phone'] ?? '';
  final role = data['role'] ?? '';
  final getqurban = data['getqurban'] ?? false;
  final verifByAdmin = data['verifByAdmin'] ?? false;

  return UserModel(id: id, name: name, nokk: nokk, phone: phone, role: role, getqurban: getqurban, verifByAdmin: verifByAdmin);
}
}


