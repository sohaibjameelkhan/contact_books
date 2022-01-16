import 'package:contact_books/Models/contact_model.dart';
import 'package:contact_books/Services/contact_services.dart';
import 'package:flutter/material.dart';

class dataEntry extends StatelessWidget {
  const dataEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactServices _contactServices = ContactServices();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          FlatButton(
              color: Colors.green,
              onPressed: () {
                _contactServices.createContact(ContactModel(
                  firstName: "Sohaib",
                  lastName: "Jameeel",
                  contactNumber: "03485149387",
                  contactId: "1",
                  contactImage:
                      "https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2021/03/28193129/Electronics.png",
                ));
              },
              child: Text(
                "Create Contact",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
