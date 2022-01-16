// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.docId.toString());

class UserModel {
  UserModel({
    this.userID,
    this.docId,
    this.firstName,
    this.userEmail,
    this.userNumber,
    this.userImage,
  });

  String? userID;
  String? docId;
  String? firstName;
  String? userEmail;
  String? userNumber;
  String? userImage;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json["userID"],
        docId: json["docID"],
        firstName: json["firstName"],
        userEmail: json["userEmail"],
        userNumber: json["userNumber"],
        userImage: json["userImage"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "userID": userID,
        "docID": docID,
        "firstName": firstName,
        "userEmail": userEmail,
        "userNumber": userNumber,
        "userImage": userImage,
      };
}
