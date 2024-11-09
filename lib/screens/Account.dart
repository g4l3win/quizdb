import 'package:flutter/material.dart';

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
        leading:
        Icon(icon, color: Colors.yellow), // Ubah warna ikon menjadi kuning
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