import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'package:quizdb/models/quiz_model.dart';
import 'package:quizdb/screens/create_trueFalse_screen.dart';
import 'create_multiplechoice_screen.dart';
import 'create_essay_screen.dart';


class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? selectedType;
  int? selectedTimer;

  // Controllers
  final TextEditingController titleController = TextEditingController();
  final List<String> subjects = ["Web Programming", "Algorithm", "Database Systems", "Mobile Programming"];
  final List<String> types = ["Pilihan Ganda", "Esai", "Benar/Salah"];
  final List<int> timers = [15, 30, 60];

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // Function to save quiz to database
  void _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a Quiz object
      final quiz = Quiz(
        title: titleController.text,
        subject: selectedCategory,
        type: selectedType,
        timer: selectedTimer,
      );

      // Insert data into the database
      await DatabaseHelper().insertQuiz(quiz);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kuis berhasil disimpan!")),
      );

      // Clear the form
      titleController.clear();
      setState(() {
        selectedCategory = null;
        selectedType = null;
        selectedTimer = null;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Kuis Baru"),
        backgroundColor: Color(0xFF00B1C2),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Judul Kuis"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text("Pilih Subject"),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih subject' : null,
              ),
              SizedBox(height: 16.0),
              Text("Pilih Tipe"),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih tipe kuis' : null,
              ),
              SizedBox(height: 16.0),
              Text("Pilih Timer"),
              DropdownButtonFormField<int>(
                value: selectedTimer,
                items: timers.map((timer) {
                  return DropdownMenuItem(
                    value: timer,
                    child: Text('$timer detik'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTimer = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih timer' : null,
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveQuiz,
                  child: Text("Simpan Kuis"),
                ),
              ),
              SizedBox(height: 16.0),
              // Button to navigate to Create Multiple Choice Quiz screen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MultipleChoiceQuizScreen()),
                  );
                },
                child: Text("Buat Kuis Pilihan Ganda"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
              SizedBox(height: 16.0),

              // Button to navigate to Create Essay Quiz screen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateEssayScreen()),
                  );
                },
                child: Text("Buat Kuis Esai"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
              SizedBox(height: 16.0),

              // Button to navigate to Create True/False Quiz screen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateTrueFalseScreen()),
                  );
                },
                child: Text("Buat Kuis Benar/Salah"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
