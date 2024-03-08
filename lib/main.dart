import 'dart:html';
import 'package:bikapikontrolsistemi/adminloginpage.dart';
import 'package:bikapikontrolsistemi/anasayfa.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCb9n9VsdYExFh8nDekx6AquJPZxqPjeB4",
          authDomain: "bilgiislemkapi.firebaseapp.com",
          projectId: "bilgiislemkapi",
          storageBucket: "bilgiislemkapi.appspot.com  ",
          messagingSenderId: "380487807369",
          appId: "1:380487807369:web:407d2b671b1d469561f158"));
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        String? userToken = window.localStorage['userToken'];
        if (userToken != null) {
          return MaterialPageRoute(builder: (context) => Anasayfa());
        } else {
          return MaterialPageRoute(builder: (context) => AdminLoginPage());
        }
      },
      debugShowCheckedModeBanner: false,
      title: 'Bozok Bilgi İşlem',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: AdminLoginPage(),
      ),
    );
  }
}
