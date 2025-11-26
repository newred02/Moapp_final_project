import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double progress;
  final List<StudySection> sections;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.sections,
  });
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
}