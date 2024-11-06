import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    await db.execute('''
    CREATE TABLE Quiz (
      quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      subject TEXT,
      type TEXT,
      timer INTEGER
    )
  ''');

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

    await db.execute('''
    CREATE TABLE Result (
      result_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      user_id INTEGER,
      score REAL,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE Mahasiswa (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT
    )
  ''');
  }

  // CRUD untuk tabel Quiz
  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    return await db.insert('Quiz', quiz.toMap());
  }

  Future<List<Quiz>> getAllQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Quiz');
    return List.generate(maps.length, (i) => Quiz.fromMap(maps[i]));
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

  // CRUD untuk tabel Question
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

  Future<Map<String, dynamic>> getQuizWithQuestions(int quizId) async {
    final db = await database;

    // Ambil data kuis
    final quizData = await db.query(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );








































    if (quizData.isEmpty) {
      return {}; // Jika tidak ada data kuis, kembalikan map kosong
    }

    // Ambil data pertanyaan yang terkait dengan kuis ini
    final questionsData = await db.query(
      'Question',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );

    // Kembalikan kuis beserta daftar soal
    return {
      'quiz': quizData.first,
      'questions': questionsData,
    };
  }

  // CRUD untuk tabel Result
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

//   Future<List<Map<String, dynamic>>> getLeaderboard(int quizId) async {
//   final db = await database;
//   return await db.rawQuery('''
//     SELECT Mahasiswa.name, Result.score
//     FROM Result
//     JOIN Mahasiswa ON Result.user_id = Mahasiswa.user_id
//     WHERE Result.quiz_id = ?
//     ORDER BY Result.score DESC
//     LIMIT 10
//   ''', [quizId]);
// }
}
