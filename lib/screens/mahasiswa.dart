import 'package:flutter/material.dart';

class Mahasiswa extends StatelessWidget {
  final List<String> namaMahasiswa = [
    "Rudi",
    "Siti",
    "Andi",
    "Dewi",
    "Budi",
    "Fitri",
    "Joko",
    "Nina",
    "Tono",
    "Lina",
  ];

  Mahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Mahasiswa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF00B1C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: namaMahasiswa.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(namaMahasiswa[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}