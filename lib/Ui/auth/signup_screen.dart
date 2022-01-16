import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_books/Models/user_model.dart';
import 'package:contact_books/Services/auth_services.dart';
import 'package:contact_books/Services/user_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Widgets/auth_textfield_widget.dart';
import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/helper.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:contact_books/Utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthServices authServices = AuthServices();
  UserServices userServices = UserServices();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _usernumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  makeLoadingTrue() {
    isLoading = true;
    setState(() {});
  }

  makeLoadingFalse() {
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return SafeArea(
        child: LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: SpinKitWave(
        color: Colors.blue,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(Res.loginbac))),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text("Create an",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 25)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text("Account",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 25)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 220,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      authtextfieldWidget(
                        maxlength: 20,
                        keyboardtype: TextInputType.name,
                        authcontroller: _firstnameController,
                        showImage: true,
                        suffixImage: Res.profileicon,
                        text: "Enter Your Name",
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      authtextfieldWidget(
                        maxlength: 40,
                        keyboardtype: TextInputType.emailAddress,
                        authcontroller: _emailController,
                        showImage: false,
                        suffixImage: "",
                        text: "Enter Your Email",
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
                        height: 20,
                      ),
                      authtextfieldWidget(
                        maxlength: 11,
                        keyboardtype: TextInputType.phone,
                        authcontroller: _usernumberController,
                        showImage: false,
                        suffixImage: "",
                        text: "Enter Your 11 digit contactNumber",
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "";
                          } else if (value.length < 9) {
                            return "";
                          } else if (value.length >= 12) {
                            return "";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      authtextfieldWidget(
                          maxlength: 15,
                          keyboardtype: TextInputType.number,
                          authcontroller: _passwordController,
                          showImage: true,
                          suffixImage: Res.passwordicon,
                          text: "Please Enter 6 digit Password",
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "";
                            } else if (value.length < 6) return "";
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 27.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot Password?",
                          style: GoogleFonts.poppins(
                              color: MyAppColors.background_color,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                buttonWidget(
                  buttonwidth: 300,
                  showborder: false,
                  text: "Sign Up",
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _signUpUser(context);
                  },
                  bacgroundcolor: MyAppColors.background_color,
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 2,
                      width: 130,
                      color: MyAppColors.grey_button_color,
                    ),
                    Text(" OR ",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 11)),
                    Container(
                      height: 2,
                      width: 130,
                      color: MyAppColors.grey_button_color,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                buttonWidget(
                    buttonwidth: 300,
                    showborder: true,
                    text: "Login",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    textColor: Colors.black,
                    bacgroundcolor: Colors.white)
              ],
            ),
          ),
        ),
      ),
    ));
  }

  _signUpUser(BuildContext context) async {
    makeLoadingTrue();
    try {
      ///This will allow user to register in firebase
      return await authServices
          .registerUser(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        userServices.createUser(UserModel(
            firstName: _firstnameController.text,
            userNumber: _usernumberController.text,
            userEmail: _emailController.text,
            userID: getUserID()));
        makeLoadingFalse();
      }).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return Fluttertoast.showToast(msg: "Registered SucessFully");
      });
    } on FirebaseAuthException catch (e) {
      makeLoadingFalse();
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('ALert!'),
            content: Text(e.message.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  makeLoadingFalse();
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        //message to show toast
        toastLength: Toast.LENGTH_LONG,
        //duration for message to show
        gravity: ToastGravity.CENTER,
        //where you want to show, top, bottom
        timeInSecForIosWeb: 1,
        //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.red,
        //message text color
        fontSize: 16.0 //message font size
        );
  }
}
