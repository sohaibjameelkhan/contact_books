import 'dart:io';
import 'dart:ui';

import 'package:contact_books/Models/contact_model.dart';
import 'package:contact_books/Services/contact_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Widgets/profile_textfield_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/helper.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../Utils/res.dart';
import 'button_widget.dart';

class AddDialoqBox extends StatefulWidget {
  @override
  _AddDialoqBoxState createState() => _AddDialoqBoxState();
}

class _AddDialoqBoxState extends State<AddDialoqBox> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  File? _image;
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
    ContactServices _contactServices = ContactServices();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60,
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
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      Text("Add Contact",
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
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3, color: MyAppColors.background_color),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _image == null
                                  ? AssetImage(Res.profileavatar)
                                  : FileImage(_image!) as ImageProvider)),
                    ),
                    Positioned.fill(
                      top: -50,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                onPressed: () {
                                  getImage(true);
                                }),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        maxlength: 20,
                        controller: firstNameController,
                        textfieldheight: 55,
                        textfieldwidth: 250,
                        text: "Enter Your FirstName",
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ProfileTextFieldWidget(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "";
                          }
                          return null;
                        },
                        maxlength: 20,
                        controller: lastNameController,
                        textfieldheight: 55,
                        textfieldwidth: 250,
                        text: "Enter Your LastName",
                      ),
                      SizedBox(
                        height: 15,
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
                        textfieldwidth: 250,
                        text: "Enter Your Number",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonWidget(
                      text: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      showborder: false,
                      textColor: Colors.white,
                      bacgroundcolor: MyAppColors.grey_button_color,
                      buttonwidth: 100,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    buttonWidget(
                      text: "Add",
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SpinKitWave(
                                  color: Colors.blue,
                                  type: SpinKitWaveType.start);
                            });

                        getUrl(context, file: _image).then((imgUrl) {
                          _contactServices.createContact(ContactModel(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              contactNumber: contactNumberController.text,
                              contactId: "1",
                              contactImage: imgUrl,
                              userID: getUserID()));
                        }).whenComplete(() =>
                            NavigationHelper.pushRoute(context, HomeScreen()));
                      },
                      showborder: false,
                      textColor: Colors.white,
                      bacgroundcolor: MyAppColors.background_color,
                      buttonwidth: 100,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
