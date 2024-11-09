import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/questionEsai_model.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Quiz table
    await db.execute('''
    CREATE TABLE Quiz (
      quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      subject TEXT,
      type TEXT,
      timer INTEGER
    )
    ''');

    // Create Question table (multiple choice)
    await db.execute('''
    CREATE TABLE Question (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      option_a TEXT,
      option_b TEXT,
      option_c TEXT,
      option_d TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Create Result table
    await db.execute('''
    CREATE TABLE Result (
      result_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      user_id INTEGER,
      score REAL,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Create Mahasiswa (Student) table
    await db.execute('''
    CREATE TABLE Mahasiswa (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT
    )
    ''');

    // Create QuestionEsai (Essay Question) table
    await db.execute('''
    CREATE TABLE QuestionEsai (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Create QuestionBenarSalah (True/False Question) table
    await db.execute('''
    CREATE TABLE QuestionBenarSalah (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');
  }

  // CRUD for Quiz table
  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    return await db.insert('Quiz', quiz.toMap());
  }

  Future<List<Quiz>> getAllQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Quiz');
    return List.generate(maps.length, (i) => Quiz.fromMap(maps[i]));
  }

  Future<Map<String, Object?>?> getQuizById(int quizId) async {
    final db = await database;
    final result = await db.query(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
      limit: 1, // Membatasi hasil hanya satu data
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateQuiz(Quiz quiz) async {
    final db = await database;
    return await db.update(
      'Quiz',
      quiz.toMap(),
      where: 'quiz_id = ?',
      whereArgs: [quiz.quizId],
    );
  }

  Future<int> deleteQuiz(int id) async {
    final db = await database;
    return await db.delete(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllQuizzes() async {
    final db = await database;
    await db.delete('Quiz'); // Delete all quizzes
  }

  // CRUD for Question (multiple choice)
  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('Question', question.toMap());
  }

  Future<List<Question>> getQuestionsByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Question',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<int> updateQuestion(Question question) async {
    final db = await database;
    return await db.update(
      'Question',
      question.toMap(),
      where: 'question_id = ?',
      whereArgs: [question.questionId],
    );
  }

  Future<int> deleteQuestion(int id) async {
    final db = await database;
    return await db.delete(
      'Question',
      where: 'question_id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for QuestionBenarSalah (True/False)
  Future<int> insertQuestionBenarSalah(Map<String, dynamic> question) async {
    final db = await database;
    return await db.insert('QuestionBenarSalah', question);
  }

  Future<List<Map<String, dynamic>>> getQuestionsBenarSalahByQuizId(int quizId) async {
    final db = await database;
    return await db.query(
      'QuestionBenarSalah',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
  }

  Future<int> updateQuestionBenarSalah(Map<String, dynamic> question, int questionId) async {
    final db = await database;
    return await db.update(
      'QuestionBenarSalah',
      question,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionBenarSalah(int questionId) async {
    final db = await database;
    return await db.delete(
      'QuestionBenarSalah',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // CRUD for QuestionEsai (Essay)
  Future<void> insertQuestionEsai(QuestionEsai questionEsai) async {
    final db = await database;
    try {
      await db.insert(
        'QuestionEsai',
        questionEsai.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting QuestionEsai: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getQuestionsEsaiByQuizId(int quizId) async {
    final db = await database;
    return await db.query(
      'QuestionEsai',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
  }

  Future<int> updateQuestionEsai(Map<String, dynamic> questionEsai, int questionId) async {
    final db = await database;
    return await db.update(
      'QuestionEsai',
      questionEsai,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionEsai(int questionId) async {
    final db = await database;
    return await db.delete(
      'QuestionEsai',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // CRUD for Result table
  Future<int> insertResult(Result result) async {
    final db = await database;
    return await db.insert('Result', result.toMap());
  }

  Future<List<Result>> getResultsByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Result',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Result.fromMap(maps[i]));
  }

  Future<int> updateResult(Result result) async {
    final db = await database;
    return await db.update(
      'Result',
      result.toMap(),
      where: 'result_id = ?',
      whereArgs: [result.resultId],
    );
  }

  Future<int> deleteResult(int id) async {
    final db = await database;
    return await db.delete(
      'Result',
      where: 'result_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getLeaderboard(int quizId) async {
    final db = await database;
    return await db.query(
      'Result',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
      orderBy: 'score DESC',
      limit: 10,
    );
  }

  Future<Map<String, dynamic>> getQuizWithQuestions(int quizId) async {
    final db = await database;

    // Join Quiz and Question tables
    final quizData = await db.rawQuery('''
    SELECT * FROM Quiz WHERE quiz_id = ?
  ''', [quizId]);

    if (quizData.isEmpty) {
      return {}; // If no quiz data, return an empty map
    }

    // Get the associated questions
    final questionsData = await db.rawQuery('''
    SELECT * FROM Question WHERE quiz_id = ?
  ''', [quizId]);

    // Return the quiz and questions as a map
    return {
      'quiz': quizData.first,
      'questions': questionsData,
    };
  }}
