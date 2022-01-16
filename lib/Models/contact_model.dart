// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) =>
    ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) =>
    json.encode(data.contactId.toString());

class ContactModel {
  ContactModel({
    this.userID,
    this.contactId,
    this.firstName,
    this.lastName,
    this.contactNumber,
    this.contactImage,
  });

  String? userID;
  String? contactId;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? contactImage;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        userID: json["userID"],
        contactId: json["contactID"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        contactNumber: json["contactNumber"],
        contactImage: json["contactImage"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "userID": userID,
        "contactID": docID,
        "firstName": firstName,
        "lastName": lastName,
        "contactNumber": contactNumber,
        "contactImage": contactImage,
      };
}
