import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'quiz_screen.dart';
//import 'materistat.dart';
//import 'leaderboard.dart';
import 'create_quiz_screen.dart'; // Import halaman baru

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final dbHelper = DatabaseHelper();
    final quizzes = await dbHelper.getAllQuizzes();
    setState(() {
      quizList = quizzes.map((quiz) => quiz.toMap()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dan Search
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xFF00B1C2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.dashboard, color: Color(0xFFFFD801), size: 30),
                      Icon(Icons.notifications,
                          color: Color(0xFFFFD801), size: 30),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Hi, Lecturer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 55,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B547A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here...",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFFFFD801)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tombol Buat Kuis, Statistik, dan Leaderboard
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Button Buat Kuis
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.add_circle,
                            color: Color(0xFF00B1C2), size: 40),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateQuizScreen()),
                          );
                        },
                      ),
                      Text("Buat Kuis", style: TextStyle(color: Colors.black)),
                    ],
                  ),

                  // Button Statistik
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.bar_chart,
                            color: Color(0xFF00B1C2), size: 40),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MateriStat()),
                          // );
                        },
                      ),
                      Text("Statistik", style: TextStyle(color: Colors.black)),
                    ],
                  ),

                  // Button Papan Peringkat
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.leaderboard,
                            color: Color(0xFF00B1C2), size: 40),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                          // );
                        },
                      ),
                      Text("Papan Peringkat",
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),

            // Grid View Kategori
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: quizList.length,
                    itemBuilder: (context, index) {
                      final quiz = quizList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizScreen(quizId: quiz['quiz_id']),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz,
                                color: Color(0xFF00B1C2), size: 50),
                            SizedBox(height: 10),
                            Text(
                              quiz['title'],
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Button Hapus Semua Kuis
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_forever,
                            color: Color(0xFF00B1C2), size: 40),
                        onPressed: () async {
                          final dbHelper = DatabaseHelper();
                          await dbHelper.deleteAllQuizzes();
                          _loadQuizzes(); // Refresh quiz list setelah menghapus semua kuis
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Semua kuis berhasil dihapus!')),
                          );
                        },
                      ),
                      Text("Hapus Semua",
                          style: TextStyle(color: Colors.black)),
                    ],
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
