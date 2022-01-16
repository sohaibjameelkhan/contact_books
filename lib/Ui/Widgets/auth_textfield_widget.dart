import 'package:contact_books/Utils/res.dart';
import 'package:flutter/material.dart';

class authtextfieldWidget extends StatelessWidget {
  final int maxlength;
  final TextEditingController authcontroller;
  final TextInputType keyboardtype;
  final String text;
  final String suffixImage;
  final bool showImage;
  final Function(String) validator;

  //final bool showSuffix;
  authtextfieldWidget(
      {required this.maxlength,
      required this.authcontroller,
      required this.keyboardtype,
      required this.text,
      required this.suffixImage,
      required this.showImage,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 300,
      child: TextFormField(
        maxLength: maxlength,
        // keyboardType: TextInputType.number,
        autocorrect: true,
        keyboardType: keyboardtype,
        controller: authcontroller,
        validator: (val) => validator(val!),
        decoration: InputDecoration(
            errorStyle: TextStyle(
              color: Colors.blue,
              fontSize: 10,
            ),
            hintText: text,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 15),
              child: showImage ? Image.asset(suffixImage) : null,
            )),
      ),
    );
  }
}
