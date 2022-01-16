import 'package:flutter/material.dart';

class ProfileTextFieldWidget extends StatelessWidget {
  final int maxlength;
  final TextEditingController controller;
  final String text;
  final double textfieldheight;
  final double textfieldwidth;
  final Function(String) validator;

  ProfileTextFieldWidget({
    required this.maxlength,
    required this.controller,
    required this.text,
    required this.textfieldheight,
    required this.textfieldwidth,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textfieldheight,
      width: textfieldwidth,
      child: TextFormField(
        maxLength: maxlength,
        validator: (val) => validator(val!),
        controller: controller,
        decoration: InputDecoration(
          //   errorBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          // focusedBorder:OutlineInputBorder(
          //   borderSide: const BorderSide(color: Colors.red, width: 2.0),),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          contentPadding: EdgeInsets.only(top: 5, left: 20),
          hintText: text,
        ),
      ),
    );
  }
}
