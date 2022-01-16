import 'package:cached_network_image/cached_network_image.dart';
import 'package:contact_books/Models/user_model.dart';
import 'package:contact_books/Services/auth_services.dart';
import 'package:contact_books/Services/user_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Screens/splash_screen.dart';
import 'package:contact_books/Ui/Screens/update_profile_screen.dart';
import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Ui/auth/login_screen.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:contact_books/Utils/res.dart';
import 'package:contact_books/helpers/auth_state_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getUI(context),
      ),
    );
  }
}

Widget _getUI(BuildContext context) {
  UserServices userServices = UserServices();
  AuthServices authServices = AuthServices();
  return Container(
    child: StreamProvider.value(
        value: userServices
            .fetchUserRecord(FirebaseAuth.instance.currentUser!.uid),
        initialData: UserModel(),
        builder: (context, child) {
          UserModel model = context.watch<UserModel>();
          return Column(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Text("Profile",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 19)),
                    IconButton(
                        onPressed: () {
                          // authServices.signOut().then((value) {
                          // // NavigationHelper.pushRoute(context, LoginScreen());
                          // });
                          UserLoginStateHandler
                                  .saveUserLoggedInSharedPreference(false)
                              .whenComplete(() {
                            Fluttertoast.showToast(msg: "LogOut SuccessFully");
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  model.userImage == null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(Res.profileavatar),
                        )
                      : CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageBuilder: (context, imageProvider) => Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          imageUrl: model.userImage.toString(),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SpinKitWave(
                                  color: Colors.blue,
                                  type: SpinKitWaveType.start),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error))
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                    Text(model.firstName.toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("Last Name",
              //           style: GoogleFonts.poppins(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontSize: 17)),
              //       Text(model.firstName.toString(),
              //           style: GoogleFonts.poppins(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w600,
              //               fontSize: 17)),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Number",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                    Text(model.userNumber.toString(),
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              buttonWidget(
                  text: "Edit Profile",
                  showborder: false,
                  buttonwidth: 120,
                  bacgroundcolor: MyAppColors.button_color,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfileScreen(
                                  model.docId.toString(),
                                  model.firstName.toString(),
                                  model.userImage.toString(),
                                  model.userNumber.toString(),
                                )));
                  })
            ],
          );
        }),
  );
}
