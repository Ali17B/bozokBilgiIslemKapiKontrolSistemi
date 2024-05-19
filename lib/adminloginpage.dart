import 'package:bikapikontrolsistemi/anasayfa.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection('adminoturum')
        .doc('QfiMadlFMFC0c2reQRCZ')
        .get();

    if (adminDoc.exists) {
      if (adminDoc['kullaniciadi'] == username &&
          adminDoc['sifre'] == password) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Anasayfa()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kullanıcı adı veya şifre yanlış!')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Admin bilgisi bulunamadı.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 150, 
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 143, 14, 5),
                  ),
                ),
                Positioned(
                  top: 15, 
                  left: 20, 
                  child: Image.asset(
                    'assets/logobozok.png', 
                    width: 120, 
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 60, 
                  left: 190, 
                  child: Text(
                    'BİLGİ İŞLEM DAİRE BAŞKANLIĞI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 500, right: 500),
              child: Column(
                children: [
                  SizedBox(height: 150),
                  Text(
                    '     YOZGAT BOZOK ÜNİVERSİTESİ\n    BİLGİ İŞLEM DAİRE BAŞKANLIĞI\nPERSONEL GİRİŞ KONTROL SİSTEMİ',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 14, 13, 13),
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(height: 100),
                  Center(
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onSubmitted: (_) => _login(),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Colors.black, width: 0)), 
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                    ),
                    child: Text(
                      'Giriş Yap',
                      style: TextStyle(
                          color: Color.fromARGB(255, 54, 50, 50),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
