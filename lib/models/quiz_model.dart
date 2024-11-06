class Quiz {
  final int? quizId;
  final String title;
  final String subject;
  final String type;
  final int timer;

  Quiz(
      {this.quizId,
      required this.title,
      required this.subject,
      required this.type,
      required this.timer});

  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'title': title,
      'subject': subject,
      'type': type,
      'timer': timer,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quiz_id'],
      title: map['title'],
      subject: map['subject'],
      type: map['type'],
      timer: map['timer'],
    );
  }
}
