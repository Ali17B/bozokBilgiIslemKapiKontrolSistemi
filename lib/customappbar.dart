import 'package:bikapikontrolsistemi/adminloginpage.dart';
import 'package:bikapikontrolsistemi/anasayfa.dart';
import 'package:bikapikontrolsistemi/giricikiskontrol.dart';
import 'package:bikapikontrolsistemi/yenipkartekle.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  @override
  final Size preferredSize;

  CustomAppBar({
    Key? key,
    required this.currentPage,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 160, 14, 4),
      title: Text(
        'BOZOK BİLGİ İŞLEM',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        _buildTextButton('Anasayfa', 'Anasayfa', context, Anasayfa(),
            color: Colors.white),
        _buildTextButton('Giriş kontrol', 'GCKontrol', context, GCKontrol(),
            color: Colors.white),
        _buildTextButton(
            'Yeni personel kart ekle', 'Ypkartekle', context, Ypkartekle(),
            color: Colors.white),
        _buildTextButton(
            'Çıkış Yap', 'AdminLoginPage', context, AdminLoginPage(),
            color: const Color.fromARGB(255, 194, 168, 166)),
      ],
    );
  }

  Widget _buildTextButton(
      String title, String pageKey, BuildContext context, Widget targetPage,
      {Color color = const Color.fromARGB(255, 255, 255, 255)}) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: currentPage == pageKey
            ? BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255), width: 2),
                borderRadius: BorderRadius.circular(8.0),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            color: currentPage == pageKey
                ? const Color.fromARGB(255, 255, 255, 255).withOpacity(1)
                : color,
          ),
        ),
      ),
    );
  }
}
