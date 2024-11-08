import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
//comint
class QuizScreen extends StatefulWidget {
  final int quizId;

  QuizScreen({required this.quizId});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<String, dynamic> quizData = {};
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getQuizWithQuestions(widget.quizId);
    setState(() {
      quizData = data['quiz'] ?? {};
      questions = data['questions'] ?? [];
    });
  }

  Future<void> _deleteAllQuestions() async {
    final dbHelper = DatabaseHelper();
    await dbHelper
        .deleteQuestion; // Call to delete all questions for the specific quiz
    await _loadQuizData(); // Reload quiz data to reflect the deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semua soal berhasil dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kuis ID: ${widget.quizId}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quizData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID Kuis: ${widget.quizId}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Judul: ${quizData['title'] ?? ''}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Mata Pelajaran: ${quizData['subject'] ?? ''}'),
                  Text('Jenis: ${quizData['type'] ?? ''}'),
                  Text('Waktu: ${quizData['timer'] ?? ''} detik'),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await _deleteAllQuestions();
                    },
                    child: Text('Hapus Semua Soal'),
                  ),
                  Text(
                    'Soal-Soal:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID Soal: ${question['question_id']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Soal ${index + 1}: ${question['content']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text('A. ${question['option_a']}'),
                              Text('B. ${question['option_b']}'),
                              Text('C. ${question['option_c']}'),
                              Text('D. ${question['option_d']}'),
                              SizedBox(height: 5),
                              Text(
                                'Jawaban Benar: ${question['answer']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
