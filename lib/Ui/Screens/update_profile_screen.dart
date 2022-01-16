import 'dart:io';

import 'package:contact_books/Models/user_model.dart';
import 'package:contact_books/Services/user_services.dart';
import 'package:contact_books/Ui/Screens/profile_screen.dart';
import 'package:contact_books/Ui/Widgets/button_widget.dart';
import 'package:contact_books/Ui/Widgets/profile_textfield_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:contact_books/Utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String docID;
  final String firstName;
  final String userimage;
  final String userNumber;

  UpdateProfileScreen(
      this.docID, this.firstName, this.userimage, this.userNumber);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UpdateProfileScreen> {
  UserServices userServices = UserServices();
  TextEditingController firstNameController = TextEditingController();

  TextEditingController contactNumberController = TextEditingController();
  File? _image;
  final _formKey = GlobalKey<FormState>();
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
  void initState() {
    ///We have to populate our text editing controllers with speicifid product details
    firstNameController = TextEditingController(text: widget.firstName);

    contactNumberController = TextEditingController(text: widget.userNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getUI(context),
      ),
    );
  }

  Widget _getUI(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Res.profilebac)
      //   )
      child: SingleChildScrollView(
        child: Column(
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 60,
                  ),
                  Text("Update Profile",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 19)),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 3, color: MyAppColors.background_color),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == null
                              ? AssetImage(Res.profileavatar)
                              : FileImage(_image!) as ImageProvider)),
                  height: 120,
                  width: 120,
                  // child: _image == null
                  //     ? Image.asset(Res.profileavatar)
                  //     : Image.file(_image!,fit: BoxFit.cover,),
                ),
                Positioned.fill(
                  top: -50,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 19,
                        ),
                        onPressed: () {
                          getImage(true);
                        },
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyAppColors.background_color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileTextFieldWidget(
                    maxlength: 20,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please Enter Name";
                      }
                      return null;
                    },
                    controller: firstNameController,
                    textfieldheight: 55,
                    textfieldwidth: 300,
                    text: "Enter Your FirstName",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ProfileTextFieldWidget(
                    maxlength: 11,
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
                    controller: contactNumberController,
                    textfieldheight: 55,
                    textfieldwidth: 300,
                    text: "Enter Your Number",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            buttonWidget(
              text: "Save",
              onTap: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SpinKitWave(
                          color: Colors.blue, type: SpinKitWaveType.start);
                    });
                _image == null
                    ?
                    //getUrl(context, file: _image).then((imgUrl) {
                    userServices
                        .updateUserDetailsWithoutImage(UserModel(
                          userID: widget.docID,
                          firstName: firstNameController.text,
                          userNumber: contactNumberController.text,
                          // userImage: imgUrl,
                        ))
                        .whenComplete(() => NavigationHelper.pushRoute(
                            context, ProfileScreen()))
                    //})
                    : getUrl(context, file: _image).then((imgUrl) {
                        userServices
                            .updateUserDetailswithImage(UserModel(
                              userID: widget.docID,
                              firstName: firstNameController.text,
                              userNumber: contactNumberController.text,
                              userImage: imgUrl,
                            ))
                            .whenComplete(() => NavigationHelper.pushRoute(
                                context, ProfileScreen()));
                      });
              },
              showborder: false,
              textColor: Colors.white,
              bacgroundcolor: MyAppColors.background_color,
              buttonwidth: 100,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getUrl(BuildContext context, {File? file}) async {
    String postFileUrl = "";
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('backendClass/${file!.path.split('/').last}');
      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        await storageReference.getDownloadURL().then((fileURL) {
          print("I am fileUrl $fileURL");
          postFileUrl = fileURL;
        });
      });
    } catch (e) {
      rethrow;
    }

    return postFileUrl.toString();
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
