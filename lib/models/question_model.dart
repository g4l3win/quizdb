class Question {
  final int? questionId;
  final int quizId;
  final String content;
  final String optionA;
  final String optionB;
  String? optionC; // Nullable
  String? optionD; // Nullable
  final String answer;

  Question({
    this.questionId,
    required this.quizId,
    required this.content,
    required this.optionA,
    required this.optionB,
    this.optionC, // Nullable
    this.optionD, // Nullable
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'quiz_id': quizId,
      'content': content,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'answer': answer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['question_id'],
      quizId: map['quiz_id'],
      content: map['content'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      optionD: map['option_d'],
      answer: map['answer'],
    );
  }
}
