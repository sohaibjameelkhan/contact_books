import 'package:contact_books/Services/auth_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Widgets/auth_textfield_widget.dart';
import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Ui/auth/signup_screen.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:contact_books/Utils/res.dart';
import 'package:contact_books/helpers/auth_state_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'fogot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthServices authServices = AuthServices();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final spinkit = SpinKitWave(
    color: Colors.white,
    size: 50.0,
  );
  bool isLoadingspin = true;

  bool isLoading = false;

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
      progressIndicator: SpinKitWave(color: Colors.blue),
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
                      Text("Welcome",
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
                      Text("Back",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 25)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 240,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      authtextfieldWidget(
                        maxlength: 40,
                        keyboardtype: TextInputType.emailAddress,
                        authcontroller: emailController,
                        showImage: true,
                        suffixImage: Res.profileicon,
                        text: "Enter Your Email",
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return "Please Enter Valid Email Address";
                          } else if (value.length <= 2)
                            return "Please Enter more than 2 words";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      authtextfieldWidget(
                          maxlength: 20,
                          keyboardtype: TextInputType.number,
                          authcontroller: passwordController,
                          showImage: true,
                          suffixImage: Res.passwordicon,
                          text: "Enter Your Password",
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please Enter more than 6 digit password";
                            } else if (value.length < 6)
                              return "Please Enter atleast 6 password";
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 27.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(


                        child: Text("Forgot Password?",
                            style: GoogleFonts.poppins(
                                color: MyAppColors.background_color,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        onTap: (){
                          NavigationHelper.pushRoute(context, ForgotPassword());
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                buttonWidget(
                  buttonwidth: 300,
                  showborder: false,
                  text: "Login",
                  onTap: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    _loginUser(context);
                  },
                  bacgroundcolor: MyAppColors.background_color,
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 15,
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
                  height: 15,
                ),
                buttonWidget(
                    buttonwidth: 300,
                    showborder: true,
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
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

  _loginUser(BuildContext context) async {
    makeLoadingTrue();

    try {
      ///This will allow user to register in firebase
      return await authServices
          .loginUser(
              email: emailController.text, password: passwordController.text)
          .whenComplete(() => makeLoadingFalse())
          .then((value) async {
        await UserLoginStateHandler.saveUserLoggedInSharedPreference(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return Fluttertoast.showToast(msg: "Login Successfully");
      });
      ;
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
