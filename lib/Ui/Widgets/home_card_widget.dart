import 'package:cached_network_image/cached_network_image.dart';
import 'package:contact_books/Services/contact_services.dart';
import 'package:contact_books/Ui/Widgets/delete_contact_dialog.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/res.dart';
import 'add_dialog_box.dart';
import 'edit_conatct_widget.dart';

class CardWidget extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String contactNumber;
  final String image;
  final String contactId;

  CardWidget(this.firstName, this.lastName, this.contactNumber, this.image,
      this.contactId);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    ContactServices _contactServices = ContactServices();
    return Column(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 3,
                      child: CachedNetworkImage(
                          height: 100,
                          width: 50,
                          imageBuilder: (context, imageProvider) => Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          imageUrl: widget.image,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SpinKitWave(
                                  color: Colors.blue,
                                  type: SpinKitWaveType.start),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error))),

                  // child: Container(
                  //      height: 100,
                  //      width: 90,
                  //      decoration: BoxDecoration(
                  //          borderRadius: BorderRadius.circular(13),
                  //          image: DecorationImage(
                  //              fit: BoxFit.cover,
                  //              image:  CachedNetworkImage(
                  //
                  //                fit: BoxFit.cover,
                  //                  progressIndicatorBuilder: (context,url, downloadProgress)=> SpinKitWave(color: Colors.blue, type: SpinKitWaveType.start),
                  //                  errorWidget: (context,url,error)=> Icon(Icons.error),
                  //
                  //                  imageUrl: widget.image.toString()) as ImageProvider
                  //          )
                  //      ),
                  //    ),

                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(widget.firstName,
                                style: GoogleFonts.poppins(
                                    color: MyAppColors.card_text_color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17)),
                            SizedBox(
                              width: 3,
                            ),
                            Text(widget.lastName,
                                style: GoogleFonts.poppins(
                                    color: MyAppColors.card_text_color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: MyAppColors.card_text_color,
                              size: 20,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(widget.contactNumber,
                                style: GoogleFonts.poppins(
                                    color: MyAppColors.card_text_color,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditDialoqBox(
                                    widget.contactId,
                                    widget.firstName,
                                    widget.lastName,
                                    widget.contactNumber,
                                    widget.image);
                              });
                        },
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              color: MyAppColors.button_color),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Edit",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteContactDialog(widget.contactId);
                              });
                        },
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              color: MyAppColors.delete_button_color),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Delete",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
