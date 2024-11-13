import 'package:flutter/material.dart';
import 'SignIn.dart'; // Pastikan path ke file SignIn.dart sudah benar

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan',
            style: TextStyle(color: Colors.white)), // Judul di AppBar
        centerTitle: true,
        backgroundColor: Color(0xFF00B1C2), // Warna AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // Spasi antara judul dan ListTile
            Expanded(
              child: ListView(
                children: [
                  // Menambahkan border pada setiap ListTile
                  _buildListTile(context, Icons.person, 'Akun', Colors.grey),
                  _buildListTile(
                      context, Icons.notifications, 'Notifikasi', Colors.black),
                  _buildListTile(
                      context, Icons.visibility, 'Tampilan', Colors.black),
                  _buildListTile(context, Icons.lock, 'Privasi dan Keamanan',
                      Colors.black),
                  _buildListTile(
                      context, Icons.help, 'Tentang Aplikasi', Colors.black),
                ],
              ),
            ),
            // Tombol Masuk / Daftar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Tindakan ketika tombol ditekan
                  // Tambahkan logika untuk log in/sign up
                },
                child: Text(
                  'Masuk / Daftar',
                  style: TextStyle(color: Colors.white), // Styling text color
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color(0xFF00B1C2), // Warna tombol
                ),
              ),
            ),
            SizedBox(height: 30), // Spasi antara tombol Masuk dan Log Out
            // Tombol Log Out di tengah
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Signin()));
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    color: Color(0xFF3B547A),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF3B547A), width: 2), // Warna border tombol
                ),
              ),
            ),
            SizedBox(height: 20), // Memberikan sedikit spasi di bawah tombol
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, Color textColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), // Spasi antar ListTile
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Warna border
        borderRadius: BorderRadius.circular(10), // Sudut border
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.yellow), // Ubah warna ikon menjadi kuning
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        onTap: () {
          // Tindakan ketika ListTile ditekan
        },
      ),
    );
  }
}
