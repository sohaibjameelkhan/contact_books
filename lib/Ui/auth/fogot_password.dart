import 'package:contact_books/Services/auth_services.dart';
import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Ui/Widgets/profile_textfield_widget.dart';
import 'package:contact_books/Ui/auth/login_screen.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: getUI(context),
      ),
    );
  }
}

Widget getUI(BuildContext context) {
  TextEditingController _controller = TextEditingController();
  AuthServices authServices = AuthServices();
  return Scaffold(
    body: Column(
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(17),
                  bottomLeft: Radius.circular(17)),
              color: MyAppColors.background_color),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 60,
              ),
              Text("Forgot Password",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 19)),
            ],
          ),
        ),
        SizedBox(
          height: 70,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter Your Email to Reset Password",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 17)),
          ],
        ),
        SizedBox(
          height: 80,
        ),
        ProfileTextFieldWidget(
          maxlength: 40,
          controller: _controller,
          text: "Enter Your Email",
          textfieldheight: 55,
          textfieldwidth: 300,
          validator: (value) {
            if (value.isEmpty ||
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
              return "";
            } else if (value.length <= 2) return "";
            return null;
          },
        ),
        SizedBox(
          height: 80,
        ),
        buttonWidget(
            text: "Send Link",
            showborder: true,
            buttonwidth: 200,
            bacgroundcolor: MyAppColors.background_color,
            textColor: Colors.white,
            onTap: () {
              authServices.resetPassword(email: _controller.text);
            })
      ],
    ),
  );
}
