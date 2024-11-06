import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'package:quizdb/models/question_model.dart';
import 'package:quizdb/models/quiz_model.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();

  String _selectedQuizType = 'Pilihan Ganda'; // Default type
  bool _isTrueFalse = false;
  String? _selectedCorrectOption;
  String? _selectedSubject; // Variable to store the selected subject

  var _answerController;

  // Daftar subject/matakuliah yang tersedia
  final List<String> _subjects = [
    'Web Programming',
    'Algorithm',
    'Database systems',
    'Mobile Programming',
  ];

  Future<void> _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DatabaseHelper();

      // Menyimpan kuis ke database (Quiz)
      final quiz = Quiz(
        title: _titleController.text,
        subject: _selectedSubject ?? 'Unknown', // Subject dari pilihan dropdown
        type: _selectedQuizType,
        timer: int.tryParse(_timerController.text) ??
            30, // Timer dari input atau default 30
      );

      final quizId = await dbHelper.insertQuiz(quiz);

      // Dapatkan jawaban yang benar berdasarkan pilihan pengguna
      String correctAnswer;
      if (_selectedQuizType == 'Pilihan Ganda') {
        switch (_selectedCorrectOption) {
          case 'A':
            correctAnswer = _optionAController.text;
            break;
          case 'B':
            correctAnswer = _optionBController.text;
            break;
          case 'C':
            correctAnswer = _optionCController.text;
            break;
          case 'D':
            correctAnswer = _optionDController.text;
            break;
          default:
            correctAnswer = '';
        }
      } else {
        correctAnswer = _answerController.text;
      }

      // Menyimpan soal kuis ke database (Question)
      final question = Question(
        quizId: quizId,
        content: _questionController.text,
        optionA: _isTrueFalse ? 'Benar' : _optionAController.text,
        optionB: _isTrueFalse ? 'Salah' : _optionBController.text,
        optionC: _selectedQuizType == 'Pilihan Ganda'
            ? _optionCController.text
            : null,
        optionD: _selectedQuizType == 'Pilihan Ganda'
            ? _optionDController.text
            : null,
        answer: correctAnswer,
      );
      await dbHelper.insertQuestion(question);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Kuis berhasil disimpan!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buat Kuis Baru')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Input Judul Kuis
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul Kuis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan judul kuis';
                  }
                  return null;
                },
              ),

              // Dropdown Pilihan Subject
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                items: _subjects.map((subject) {
                  return DropdownMenuItem(value: subject, child: Text(subject));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Subject/Matakuliah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih subject';
                  }
                  return null;
                },
              ),

              // Dropdown Pilihan Tipe Kuis
              DropdownButtonFormField<String>(
                value: _selectedQuizType,
                items: ['Pilihan Ganda', 'Esai', 'Benar/Salah'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedQuizType = value!;
                    _isTrueFalse = value == 'Benar/Salah';
                  });
                },
                decoration: InputDecoration(labelText: 'Tipe Kuis'),
              ),

              // Input Pertanyaan
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan pertanyaan';
                  }
                  return null;
                },
              ),

              // Input Timer
              TextFormField(
                controller: _timerController,
                decoration: InputDecoration(labelText: 'Durasi Timer (detik)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan durasi timer';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Durasi timer harus berupa angka';
                  }
                  return null;
                },
              ),

              // Input Jawaban untuk tipe Pilihan Ganda
              if (_selectedQuizType == 'Pilihan Ganda') ...[
                TextFormField(
                  controller: _optionAController,
                  decoration: InputDecoration(labelText: 'Pilihan A'),
                ),
                TextFormField(
                  controller: _optionBController,
                  decoration: InputDecoration(labelText: 'Pilihan B'),
                ),
                TextFormField(
                  controller: _optionCController,
                  decoration: InputDecoration(labelText: 'Pilihan C'),
                ),
                TextFormField(
                  controller: _optionDController,
                  decoration: InputDecoration(labelText: 'Pilihan D'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCorrectOption,
                  items: ['A', 'B', 'C', 'D'].map((option) {
                    return DropdownMenuItem(
                        value: option, child: Text('Opsi $option'));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCorrectOption = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Jawaban Benar'),
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih jawaban benar';
                    }
                    return null;
                  },
                ),
              ],

              // Input Jawaban untuk tipe Benar/Salah atau Esai
              if (_selectedQuizType == 'Benar/Salah' ||
                  _selectedQuizType == 'Esai')
                TextFormField(
                  controller: _answerController,
                  decoration: InputDecoration(
                      labelText: _selectedQuizType == 'Esai'
                          ? 'Jawaban Esai'
                          : 'Jawaban (Benar/Salah)'),
                ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuiz,
                child: Text('Simpan Kuis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
