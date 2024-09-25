import 'package:Peetie/signup.dart';
import 'package:flutter/material.dart';
import 'package:Peetie/googlesheets.dart';
//import 'package:flutter/rendering.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //FlutterNativeSplash.remove();
  await SheetsAPI.init();
  //debugPaintSizeEnabled = true;   // show border of object
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Define a custom TextStyle
  static const TextStyle customTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peetie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SignUpHome(),
    );
  }
}
