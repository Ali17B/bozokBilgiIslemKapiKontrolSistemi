import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
      home: GCKontrol(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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

class GCKontrol extends StatefulWidget {
  @override
  _GCKontrolState createState() => _GCKontrolState();
}

class _GCKontrolState extends State<GCKontrol> {
  final TextEditingController _personelAramaController =
      TextEditingController();
  final TextEditingController _tarihBaslangicController =
      TextEditingController();
  final TextEditingController _tarihBitisController = TextEditingController();

  List<DocumentSnapshot> _girisKayitlari = [];

  @override
  void initState() {
    super.initState();
    _bugunGirisYapanlariGetir();
  }

  void _bugunGirisYapanlariGetir() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('kapiGirisBilgi')
        .where('timestamp',
            isGreaterThanOrEqualTo:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(startOfDay))
        .orderBy('timestamp')
        .get();

    setState(() {
      _girisKayitlari = snapshot.docs;
    });
  }

  void _personelArama() async {
    String personelAdi = _personelAramaController.text.trim();
    if (personelAdi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir personel adı girin')),
      );
      return;
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kapiGirisBilgi')
          .where('name', isEqualTo: personelAdi)
          .orderBy('timestamp')
          .get();

      setState(() {
        _girisKayitlari = snapshot.docs;
      });
    } catch (e) {
      print("Sorgu hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu, lütfen tekrar deneyin')),
      );
    }
  }

  void _tarihSaatArama() async {
    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    try {
      DateTime baslangicTarihi =
          dateFormat.parse(_tarihBaslangicController.text.trim());
      DateTime bitisTarihi = dateFormat
          .parse(_tarihBitisController.text.trim())
          .add(Duration(days: 1))
          .subtract(Duration(seconds: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('kapiGirisBilgi')
          .where('timestamp',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(baslangicTarihi))
          .where('timestamp',
              isLessThanOrEqualTo:
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(bitisTarihi))
          .orderBy('timestamp')
          .get();

      setState(() {
        _girisKayitlari = snapshot.docs;
      });
    } catch (e) {
      print("Tarih formatı hatalı: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarih formatı hatalı')),
      );
    }
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestamp, true).toLocal();
    // Türkiye saat dilimine göre ayarla
    dateTime = dateTime.add(Duration(hours: -3));
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: CustomAppBar(currentPage: 'GCKontrol'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logobozok.png', height: 100, width: 100),
              SizedBox(height: 20),
              Text(
                "GİRİŞ KONTROL SAYFASI",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _personelAramaController,
                labelText: 'Personel Ara',
                icon: Icons.search,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _tarihBaslangicController,
                labelText: 'Başlangıç Tarihi (gg.aa.yyyy)',
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _tarihBitisController,
                labelText: 'Bitiş Tarihi (gg.aa.yyyy)',
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 20),
              _buildButton(
                text: 'Personel Ara',
                onPressed: _personelArama,
              ),
              SizedBox(height: 20),
              _buildButton(
                text: 'Tarih ve Saat Bazlı Ara',
                onPressed: _tarihSaatArama,
              ),
              SizedBox(height: 40),
              Text(
                "Bu Günün Giriş Kayıtları",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView.builder(
                    itemCount: _girisKayitlari.length,
                    itemBuilder: (context, index) {
                      var kayit =
                          _girisKayitlari[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(
                          "${kayit['name']} ${kayit['surname']} - ${formatTimestamp(kayit['timestamp'])}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        leading: Icon(
                          Icons.person,
                          color: Colors.blue.shade800,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
