import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bikapikontrolsistemi/customappbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: Ypkartekle(),
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

class Ypkartekle extends StatefulWidget {
  @override
  _YpkartekleState createState() => _YpkartekleState();
}

class _YpkartekleState extends State<Ypkartekle> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _cardUidController = TextEditingController();

  bool isDeviceConnected = false;
  WebSocketChannel? channel;

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  Future<void> _saveData() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String cardUid = _cardUidController.text;

    if (name.isNotEmpty && surname.isNotEmpty && cardUid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('kartlar').add({
          'name': name,
          'surname': surname,
          'cardUid': cardUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veri başarıyla kaydedildi')),
        );
        _nameController.clear();
        _surnameController.clear();
        _cardUidController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veri kaydedilirken bir hata oluştu: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(currentPage: 'Ypkartekle'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 500),
              child: Column(
                children: [
                  Image.asset('assets/logobozok.png', height: 100, width: 100),
                  SizedBox(height: 20),
                  Text(
                    "YENİ PERSONEL KART EKLEME SAYFASI",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'İsim',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                        labelText: 'Soy İsim',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _cardUidController,
                    decoration: InputDecoration(
                        labelText: 'Kart UID',
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: _saveData,
                    child: Text(
                      'Kaydet',
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
