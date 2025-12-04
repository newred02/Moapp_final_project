import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<StudySection> sections;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.sections,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'sections': sections.map((x) => x.toMap()).toList(),
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: IconData(
        map['iconCodePoint'] ?? 0xe158,
        fontFamily: map['iconFontFamily'] ?? 'MaterialIcons',
      ),
      sections: List<StudySection>.from(
        (map['sections'] as List<dynamic>? ?? []).map<StudySection>(
              (x) => StudySection.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class StudySection {
  final String id;
  final String title;
  final String content;
  final Quiz quiz;
  final bool isCompleted;

  const StudySection({
    required this.id,
    required this.title,
    required this.content,
    required this.quiz,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'quiz': quiz.toMap(),
      'isCompleted': isCompleted,
    };
  }

  factory StudySection.fromMap(Map<String, dynamic> map) {
    return StudySection(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      quiz: Quiz.fromMap(map['quiz'] as Map<String, dynamic>),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}

class Quiz {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  const Quiz({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? 0,
      explanation: map['explanation'] ?? '',
    );
  }
}

class InterviewQuestion {
  final String id;
  final String question;
  final String type;
  final String difficulty;

  const InterviewQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'difficulty': difficulty,
    };
  }

  factory InterviewQuestion.fromMap(Map<String, dynamic> map) {
    return InterviewQuestion(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      type: map['type'] ?? '',
      difficulty: map['difficulty'] ?? '',
    );
  }
}