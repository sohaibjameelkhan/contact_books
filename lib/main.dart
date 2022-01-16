import 'package:contact_books/Ui/Screens/home_screen.dart';
import 'package:contact_books/Ui/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Ui/auth/login_screen.dart';
import 'dataEntryHandler/data_entry_handler.dart';
import 'helpers/auth_state_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() {
    UserLoginStateHandler.getUserLoggedInSharedPreference().then((value) {
      if (value == null) {
        isLoggedIn = false;
      } else {
        isLoggedIn = value;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLoggedIn ? HomeScreen() : LoginScreen()
        //  home: SplashScreen()

        );
  }
}
