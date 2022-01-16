import 'dart:io';
import 'dart:ui';

import 'package:contact_books/Models/contact_model.dart';
import 'package:contact_books/Services/contact_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Widgets/profile_textfield_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:file_picker/file_picker.dart';

import '../../Utils/res.dart';
import 'button_widget.dart';

class EditDialoqBox extends StatefulWidget {
  final String ContactId;
  final String FirstName;
  final String LastName;
  final String ContactNumber;
  final String ContactImage;

  EditDialoqBox(this.ContactId, this.FirstName, this.LastName,
      this.ContactNumber, this.ContactImage);

  @override
  _EditDialoqBoxState createState() => _EditDialoqBoxState();
}

class _EditDialoqBoxState extends State<EditDialoqBox> {
  TextEditingController _firstnameupdateController = TextEditingController();
  TextEditingController _lastnameupdateController = TextEditingController();
  TextEditingController contactNumberupdateController = TextEditingController();
  File? _image;
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
    _firstnameupdateController = TextEditingController(text: widget.FirstName);
    _lastnameupdateController = TextEditingController(text: widget.LastName);
    contactNumberupdateController =
        TextEditingController(text: widget.ContactNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactServices contactServices = ContactServices();
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
                      Text("Edit Contact",
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
                                  ? NetworkImage(widget.ContactImage.toString())
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
                ProfileTextFieldWidget(
                  maxlength: 20,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter Name";
                    }
                    return null;
                  },
                  controller: _firstnameupdateController,
                  textfieldheight: 55,
                  textfieldwidth: 250,
                  text: "Enter Your FirstName",
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileTextFieldWidget(
                  maxlength: 20,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter LastName";
                    }
                    return null;
                  },
                  controller: _lastnameupdateController,
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
                      return "Please Enter Mobile Number";
                    } else if (value.length < 9) {
                      return "Enter 10 Digit Phone Number";
                    } else if (value.length >= 12) {
                      return "Please Enter less than 12 digits";
                    }
                    return null;
                  },
                  controller: contactNumberupdateController,
                  textfieldheight: 55,
                  textfieldwidth: 250,
                  text: "Enter Your Number",
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
                      text: "Save",
                      onTap: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return SpinKitWave(
                                  color: Colors.blue,
                                  type: SpinKitWaveType.start);
                            });
                        _image == null
                            ?
                            // getUrl(context, file: _image).then((imgUrl) {
                            contactServices
                                .updateContactwithoutImage(ContactModel(
                                  contactId: widget.ContactId,
                                  firstName: _firstnameupdateController.text,
                                  lastName: _lastnameupdateController.text,
                                  contactNumber:
                                      contactNumberupdateController.text,
                                  // contactImage: imgUrl,
                                ))
                                .whenComplete(() => NavigationHelper.pushRoute(
                                    context, HomeScreen()))
                            // })
                            : getUrl(context, file: _image).then((imgUrl) {
                                contactServices
                                    .updateContactwithImage(ContactModel(
                                      contactId: widget.ContactId,
                                      firstName:
                                          _firstnameupdateController.text,
                                      lastName: _lastnameupdateController.text,
                                      contactNumber:
                                          contactNumberupdateController.text,
                                      contactImage: imgUrl,
                                    ))
                                    .whenComplete(() =>
                                        NavigationHelper.pushRoute(
                                            context, HomeScreen()));
                              });
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
