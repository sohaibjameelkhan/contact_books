import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_books/Models/contact_model.dart';
import 'package:contact_books/Utils/helper.dart';

class ContactServices {
  //Add Contact
  Future createContact(ContactModel contactModel) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("contactsCollection").doc();
    return await docRef.set(contactModel.toJson(docRef.id));
  }

  ///Update Contact with image
  Future updateContactwithImage(ContactModel contactModel) async {
    return await FirebaseFirestore.instance
        .collection("contactsCollection")
        .doc(contactModel.contactId)
        .set({
      "firstName": contactModel.firstName,
      "lastName": contactModel.lastName,
      "contactNumber": contactModel.contactNumber,
      "contactImage": contactModel.contactImage,
    }, SetOptions(merge: true));
  }

  ///Update Contact without image
  Future updateContactwithoutImage(ContactModel contactModel) async {
    return await FirebaseFirestore.instance
        .collection("contactsCollection")
        .doc(contactModel.contactId)
        .set({
      "firstName": contactModel.firstName,
      "lastName": contactModel.lastName,
      "contactNumber": contactModel.contactNumber,
    }, SetOptions(merge: true));
  }

  ///Get All contacts
  Stream<List<ContactModel>> streamContacts() {
    return FirebaseFirestore.instance
        .collection('contactsCollection')
        .where('userID', isEqualTo: getUserID())
        .snapshots()
        .map((list) => list.docs
            .map((singleDoc) => ContactModel.fromJson(singleDoc.data()))
            .toList());
  }

  ///Delete Product
  Future deleteContact(String contactID) async {
    return await FirebaseFirestore.instance
        .collection("contactsCollection")
        .doc(contactID)
        .delete();
  }
}
