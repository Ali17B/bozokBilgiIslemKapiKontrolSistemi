import 'package:bikapikontrolsistemi/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      home: Anasayfa(),
    );
  }
}

class AuthProvider extends ChangeNotifier {
  String? _username;

  String? get username => _username;

  void login(String username) {
    _username = username;
    notifyListeners();
  }

  void logout() {
    _username = null;
    notifyListeners();
  }
}

class Anasayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(179, 197, 191, 191),
      appBar: CustomAppBar(currentPage: 'Anasayfa'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logobozok.png', height: 100, width: 100),
            SizedBox(height: 20),
            Text(
              "BOBİ PERSONEL GİRİŞ KONTROL SİSTEMİNE HOŞ GELDİNİZ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
