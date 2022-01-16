import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Ui/auth/login_screen.dart';
import 'package:contact_books/Ui/auth/signup_screen.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:contact_books/Utils/res.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppColors.background_color,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(Res.splashbac))),
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
                height: 380,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Contact book",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              buttonWidget(
                buttonwidth: 300,
                showborder: false,
                text: "Login",
                onTap: () {
                  NavigationHelper.pushRoute(context, LoginScreen());
                },
                bacgroundcolor: Colors.white,
                textColor: MyAppColors.background_color,
              ),
              SizedBox(
                height: 20,
              ),
              buttonWidget(
                buttonwidth: 300,
                showborder: true,
                text: "Sign Up",
                onTap: () {
                  NavigationHelper.pushRoute(context, SignUpScreen());
                },
                textColor: Colors.white,
                bacgroundcolor: MyAppColors.background_color,
              )
            ],
          ),
        ));
  }
}
