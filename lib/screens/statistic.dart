import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quizdb/database/database_helper.dart';

class Statistik extends StatefulWidget {
  final String subject;
  const Statistik({Key? key, required this.subject}) : super(key: key);

  @override
  State<Statistik> createState() => _Statistik();
}

class _Statistik extends State<Statistik> {
  List<String> quizNames = [];
  List<int> currentDistribusi = []; // ubah ke List<int>
  int totalStudents = 0;
  List<String> quizTypes = ['Pilihan Ganda', 'Esai', 'Benar/Salah'];
  String selectedQuizType = 'Pilihan Ganda';
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadQuizTitles();
    _loadData();
  }

  Future<void> _loadQuizTitles() async {
    // Memuat judul kuis dari database sesuai dengan tipe dan subjek
    quizNames = await dbHelper.getQuizByTypeAndSubject(selectedQuizType, widget.subject);
    setState(() {});
  }

  Future<void> _loadData() async {
    // Memuat distribusi skor dan total mahasiswa sesuai tipe dan subjek
    currentDistribusi = await dbHelper.getScoresByQuizTypeAndSubject(selectedQuizType, widget.subject);
    totalStudents = await dbHelper.getTotalStudentsByTypeAndSubject(selectedQuizType, widget.subject);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00B1C2),
        title: Text(
          'Statistik Nilai Kuis ${widget.subject}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: quizTypes.map((type) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        selectedQuizType = type; // Set tipe kuis yang dipilih
                      });
                      await _loadQuizTitles(); // Memuat judul kuis yang sesuai dengan tipe
                      await _loadData(); // Memuat data skor sesuai tipe dan subjek
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedQuizType == type ? Color(0xFFFFD801) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedQuizType == type ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: 400,
              height: 400,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  barGroups: _generateBarGroups(currentDistribusi),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() < currentDistribusi.length) {
                            return Text(currentDistribusi[value.toInt()].toString());
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total Mahasiswa : $totalStudents",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quizNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    currentDistribusi;
                    totalStudents;
                  },
                  child: _buildProductItem(quizNames[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<int> distribusi) {
    return List.generate(
      distribusi.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: distribusi[index].toDouble(),
            color: Color(0xFFFFD801),
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String name) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF3B547A),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
