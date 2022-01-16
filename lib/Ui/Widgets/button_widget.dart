import 'package:contact_books/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class buttonWidget extends StatelessWidget {
  final String text;
  final bool showborder;
  final double buttonwidth;
  final Color bacgroundcolor;
  final Color textColor;
  final VoidCallback onTap;

  buttonWidget(
      {required this.text,
      required this.showborder,
      required this.buttonwidth,
      required this.bacgroundcolor,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 40,
        width: buttonwidth,
        decoration: BoxDecoration(
            border:
                showborder ? Border.all(color: Colors.blue, width: 2) : null,
            color: bacgroundcolor,
            borderRadius: BorderRadius.circular(13)),
        child: Center(
          child: Text(text,
              style: GoogleFonts.poppins(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 17)),
        ),
      ),
    );
  }
}
