import 'dart:ui';

import 'package:contact_books/Services/contact_services.dart';
import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Widgets/profile_textfield_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../Utils/res.dart';
import 'button_widget.dart';

class DeleteContactDialog extends StatefulWidget {
  final String contactID;

  DeleteContactDialog(this.contactID);

  @override
  _DeleteContactDialogState createState() => _DeleteContactDialogState();
}

class _DeleteContactDialogState extends State<DeleteContactDialog> {
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
    ContactServices _contactServices = ContactServices();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.0)), //this right here
        child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Are you sure to delete this",
                      style: GoogleFonts.poppins(
                          color: MyAppColors.card_text_color,
                          fontWeight: FontWeight.w600,
                          fontSize: 17)),
                  Text("contact?",
                      style: GoogleFonts.poppins(
                          color: MyAppColors.card_text_color,
                          fontWeight: FontWeight.w600,
                          fontSize: 17)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",
                        style: GoogleFonts.poppins(
                            color: MyAppColors.card_text_color,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    color: MyAppColors.grey_button_color,
                    height: 20,
                    width: 3,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return SpinKitWave(
                                color: Colors.blue,
                                type: SpinKitWaveType.start);
                          });

                      _contactServices
                          .deleteContact(widget.contactID)
                          .whenComplete(() => NavigationHelper.pushRoute(
                              context, HomeScreen()));
                    },
                    child: Text("Delete",
                        style: GoogleFonts.poppins(
                            color: MyAppColors.delete_button_color,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
