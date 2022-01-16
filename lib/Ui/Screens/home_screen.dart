import 'package:cached_network_image/cached_network_image.dart';
import 'package:contact_books/Models/contact_model.dart';
import 'package:contact_books/Models/user_model.dart';
import 'package:contact_books/Services/contact_services.dart';
import 'package:contact_books/Services/user_services.dart';
import 'package:contact_books/Ui/Screens/profile_screen.dart';
import 'package:contact_books/Ui/Screens/update_profile_screen.dart';
import 'package:contact_books/Ui/Widgets/add_dialog_box.dart';
import 'package:contact_books/Ui/Widgets/home_card_widget.dart';
import 'package:contact_books/Utils/constants.dart';
import 'package:contact_books/Utils/navigation_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Utils/res.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ContactModel> searchedContact = [];

  List<ContactModel> contactList = [];

  bool isSearchingAllow = false;
  bool isSearched = false;
  List<ContactModel> contactListDB = [];

  void _searchedContacts(String val) async {
    print(contactListDB.length);
    searchedContact.clear();
    for (var i in contactListDB) {
      var lowerCaseString = i.firstName.toString().toLowerCase() +
          " " +
          i.lastName.toString().toLowerCase() +
          i.contactNumber.toString();

      var defaultCase = i.firstName.toString() +
          " " +
          i.lastName.toString() +
          i.contactNumber.toString();

      if (lowerCaseString.contains(val) || defaultCase.contains(val)) {
        searchedContact.add(i);
      } else {
        setState(() {
          isSearched = true;
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddDialoqBox();
                  });
            },
            child: Icon(Icons.add),
            backgroundColor: MyAppColors.background_color,
          ),
        ),
        body: _getUI(context),
      ),
    );
  }

  Widget _getUI(BuildContext context) {
    ContactServices _contactServices = ContactServices();
    UserServices userServices = UserServices();

    return SafeArea(
      child: SingleChildScrollView(
          child: StreamProvider.value(
              value: userServices
                  .fetchUserRecord(FirebaseAuth.instance.currentUser!.uid),
              initialData: UserModel(),
              builder: (context, child) {
                UserModel model = context.watch<UserModel>();

                return Column(children: [
                  Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: MyAppColors.background_color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Welcome  " + model.firstName.toString(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17)),
                              InkWell(
                                onTap: () {
                                  NavigationHelper.pushRoute(
                                      context, ProfileScreen());
                                },
                                child: Stack(
                                  children: [
                                    model.userImage == null
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                AssetImage(Res.profileavatar),
                                          )
                                        : CachedNetworkImage(
                                            height: 50,
                                            width: 50,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                  width: 80.0,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                            imageUrl:
                                                model.userImage.toString(),
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                SpinKitWave(
                                                    color: Colors.blue,
                                                    type:
                                                        SpinKitWaveType.start),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  height: 45,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Colors.white),
                                  child: TextFormField(
                                    onChanged: (val) {
                                      _searchedContacts(val);
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Find Contacts",
                                        hintStyle: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13),
                                        prefixIcon: Icon(Icons.search)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    height: 45,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.white),
                                    child: Center(
                                      child: Icon(
                                        Icons.search,
                                        color: MyAppColors.background_color,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamProvider.value(
                      value: _contactServices.streamContacts(),
                      initialData: [ContactModel()],
                      builder: (context, child) {
                        contactListDB = context.watch<List<ContactModel>>();
                        List<ContactModel> list =
                            context.watch<List<ContactModel>>();
                        return list.isEmpty
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: Text("Add Contacts",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                              ))
                            : list[0].contactId == null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: SpinKitWave(
                                          color: Colors.blue,
                                          type: SpinKitWaveType.start),
                                    ),
                                  )
                                : list.isEmpty
                                    ? Center(child: Text("No Data"))
                                    : searchedContact.isEmpty
                                        ? isSearched == true
                                            ? Center(child: Text("NO Data"))
                                            : Container(
                                                // height: 550,
                                                // width: MediaQuery.of(context).size.width,

                                                child: ListView.builder(
                                                    itemCount: list.length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemBuilder: (context, i) {
                                                      return CardWidget(
                                                        list[i]
                                                            .firstName
                                                            .toString(),
                                                        list[i]
                                                            .lastName
                                                            .toString(),
                                                        list[i]
                                                            .contactNumber
                                                            .toString(),
                                                        list[i]
                                                            .contactImage
                                                            .toString(),
                                                        list[i]
                                                            .contactId
                                                            .toString(),
                                                      );
                                                    }))
                                        : Container(
                                            // height: 550,
                                            // width: MediaQuery.of(context).size.width,

                                            child: ListView.builder(
                                                itemCount:
                                                    searchedContact.length,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, i) {
                                                  return CardWidget(
                                                    searchedContact[i]
                                                        .firstName
                                                        .toString(),
                                                    searchedContact[i]
                                                        .lastName
                                                        .toString(),
                                                    searchedContact[i]
                                                        .contactNumber
                                                        .toString(),
                                                    searchedContact[i]
                                                        .contactImage
                                                        .toString(),
                                                    searchedContact[i]
                                                        .contactId
                                                        .toString(),
                                                  );
                                                }));
                      })
                ]);
              })),
    );
  }
}
