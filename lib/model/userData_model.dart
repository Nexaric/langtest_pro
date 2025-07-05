// ignore_for_file: file_names

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String uid;
  String firstName;
  String lastName;
  String phone;
  String dob;
  String gender;
  String email;
  String role;
  bool isCompleted;

  UserData({
    required this.uid,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.email,
    required this.role,
    required this.isCompleted, 
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    uid: json['uid'],
    phone: json["phone"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dob: json["dob"],
    gender: json["gender"],
    email: json["email"],
    role: json["role"],
    isCompleted: json["isCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "phone": phone,
    "first_name": firstName,
    "last_name": lastName,
    "dob": dob,
    "gender": gender,
    "email": email,
    "role": role,
    "isCompleted": isCompleted,
  };
}
