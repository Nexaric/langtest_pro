// lib/exams/ielts/exams/listening_audio.dart

import 'package:flutter/material.dart';

// Import all lesson question files
import 'lesson1_questions.dart' as Lesson1;
import 'lesson2_questions.dart' as Lesson2;
import 'lesson3_questions.dart' as Lesson3;
import 'lesson4_questions.dart' as Lesson4;
import 'lesson5_questions.dart' as Lesson5;
import 'lesson6_questions.dart' as Lesson6;
import 'lesson7_questions.dart' as Lesson7;
import 'lesson8_questions.dart' as Lesson8;
import 'lesson9_questions.dart' as Lesson9;
import 'lesson10_questions.dart' as Lesson10;
import 'lesson11_questions.dart' as Lesson11;
import 'lesson12_questions.dart' as Lesson12;
import 'lesson13_questions.dart' as Lesson13;
import 'lesson14_questions.dart' as Lesson14;
import 'lesson15_questions.dart' as Lesson15;
import 'lesson16_questions.dart' as Lesson16;
import 'lesson17_questions.dart' as Lesson17;
import 'lesson18_questions.dart' as Lesson18;
import 'lesson19_questions.dart' as Lesson19;
import 'lesson20_questions.dart' as Lesson20;
import 'lesson21_questions.dart' as Lesson21;
import 'lesson22_questions.dart' as Lesson22;
import 'lesson23_questions.dart' as Lesson23;
import 'lesson24_questions.dart' as Lesson24;
import 'lesson25_questions.dart' as Lesson25;
import 'lesson26_questions.dart' as Lesson26;
import 'lesson27_questions.dart' as Lesson27;
import 'lesson28_questions.dart' as Lesson28;
import 'lesson29_questions.dart' as Lesson29;
import 'lesson30_questions.dart' as Lesson30;
import 'lesson31_questions.dart' as Lesson31;
import 'lesson32_questions.dart' as Lesson32;
import 'lesson33_questions.dart' as Lesson33;
import 'lesson34_questions.dart' as Lesson34;
import 'lesson35_questions.dart' as Lesson35;
import 'lesson36_questions.dart' as Lesson36;
import 'lesson37_questions.dart' as Lesson37;
import 'lesson38_questions.dart' as Lesson38;
import 'lesson39_questions.dart' as Lesson39;
import 'lesson40_questions.dart' as Lesson40;
import 'lesson41_questions.dart' as Lesson41;
import 'lesson42_questions.dart' as Lesson42;
import 'lesson43_questions.dart' as Lesson43;
import 'lesson44_questions.dart' as Lesson44;
import 'lesson45_questions.dart' as Lesson45;
import 'lesson46_questions.dart' as Lesson46;
import 'lesson47_questions.dart' as Lesson47;
import 'lesson48_questions.dart' as Lesson48;
import 'lesson49_questions.dart' as Lesson49;
import 'lesson50_questions.dart' as Lesson50;

class QuestionManager {
  // Group configuration for lessons
  static const Map<int, Map<String, int>> _groupConfig = {
    1: {
      'questionsPerQuiz': 10,
      'passThreshold': 6,
      'totalQuestions': 20,
    }, // Group 1: Lessons 1-10
    2: {
      'questionsPerQuiz': 12,
      'passThreshold': 8,
      'totalQuestions': 25,
    }, // Group 2: Lessons 11-20
    3: {
      'questionsPerQuiz': 14,
      'passThreshold': 9,
      'totalQuestions': 30,
    }, // Group 3: Lessons 21-30
    4: {
      'questionsPerQuiz': 16,
      'passThreshold': 11,
      'totalQuestions': 35,
    }, // Group 4: Lessons 31-40
    5: {
      'questionsPerQuiz': 20,
      'passThreshold': 14,
      'totalQuestions': 40,
    }, // Group 5: Lessons 41-50
  };

  /// Gets the group number for a lesson
  static int _getGroupForLesson(int lessonId) {
    if (lessonId <= 10) return 1;
    if (lessonId <= 20) return 2;
    if (lessonId <= 30) return 3;
    if (lessonId <= 40) return 4;
    return 5;
  }

  /// Gets a random set of questions for the specified lesson based on group rules
  static List<Map<String, dynamic>> getQuestionsForLesson(int lessonId) {
    if (lessonId == 1) return []; // Lesson 1 has no questions

    final group = _getGroupForLesson(lessonId);
    final questionsPerQuiz = _groupConfig[group]!['questionsPerQuiz']!;
    final allQuestions = _getAllQuestionsForLesson(lessonId);

    // Validate we have enough questions
    if (allQuestions.length < questionsPerQuiz) {
      throw Exception(
        "Lesson $lessonId has insufficient questions (${allQuestions.length}). Need at least $questionsPerQuiz.",
      );
    }

    // Make a copy to avoid modifying the original list
    final shuffledQuestions = List<Map<String, dynamic>>.from(allQuestions);

    // Shuffle and take the required number of questions
    shuffledQuestions.shuffle();
    return shuffledQuestions.take(questionsPerQuiz).toList();
  }

  /// Checks if the user's score meets the group-specific passing criteria
  static bool isLessonPassed(int score, int lessonId) {
    if (lessonId == 1) return true; // Lesson 1 passes automatically
    final group = _getGroupForLesson(lessonId);
    final passThreshold = _groupConfig[group]!['passThreshold']!;
    return score >= passThreshold;
  }

  /// Returns the total number of available lessons
  static int get totalLessons {
    return 50;
  }

  /// Gets all questions for a specific lesson
  static List<Map<String, dynamic>> _getAllQuestionsForLesson(int lessonId) {
    switch (lessonId) {
      case 1:
        return Lesson1.questions;
      case 2:
        return Lesson2.questions;
      case 3:
        return Lesson3.questions;
      case 4:
        return Lesson4.questions;
      case 5:
        return Lesson5.questions;
      case 6:
        return Lesson6.questions;
      case 7:
        return Lesson7.questions;
      case 8:
        return Lesson8.questions;
      case 9:
        return Lesson9.questions;
      case 10:
        return Lesson10.questions;
      case 11:
        return Lesson11.questions;
      case 12:
        return Lesson12.questions;
      case 13:
        return Lesson13.questions;
      case 14:
        return Lesson14.questions;
      case 15:
        return Lesson15.questions;
      case 16:
        return Lesson16.questions;
      case 17:
        return Lesson17.questions;
      case 18:
        return Lesson18.questions;
      case 19:
        return Lesson19.questions;
      case 20:
        return Lesson20.questions;
      case 21:
        return Lesson21.questions;
      case 22:
        return Lesson22.questions;
      case 23:
        return Lesson23.questions;
      case 24:
        return Lesson24.questions;
      case 25:
        return Lesson25.questions;
      case 26:
        return Lesson26.questions;
      case 27:
        return Lesson27.questions;
      case 28:
        return Lesson28.questions;
      case 29:
        return Lesson29.questions;
      case 30:
        return Lesson30.questions;
      case 31:
        return Lesson31.questions;
      case 32:
        return Lesson32.questions;
      case 33:
        return Lesson33.questions;
      case 34:
        return Lesson34.questions;
      case 35:
        return Lesson35.questions;
      case 36:
        return Lesson36.questions;
      case 37:
        return Lesson37.questions;
      case 38:
        return Lesson38.questions;
      case 39:
        return Lesson39.questions;
      case 40:
        return Lesson40.questions;
      case 41:
        return Lesson41.questions;
      case 42:
        return Lesson42.questions;
      case 43:
        return Lesson43.questions;
      case 44:
        return Lesson44.questions;
      case 45:
        return Lesson45.questions;
      case 46:
        return Lesson46.questions;
      case 47:
        return Lesson47.questions;
      case 48:
        return Lesson48.questions;
      case 49:
        return Lesson49.questions;
      case 50:
        return Lesson50.questions;
      default:
        throw Exception("Questions for lesson $lessonId not found");
    }
  }

  /// Validates the structure of all questions in a lesson
  static void validateLessonQuestions(int lessonId) {
    if (lessonId == 1) return; // Lesson 1 has no questions

    final group = _getGroupForLesson(lessonId);
    final totalQuestions = _groupConfig[group]!['totalQuestions']!;
    final questions = _getAllQuestionsForLesson(lessonId);

    if (questions.length < totalQuestions) {
      debugPrint(
        "Warning: Lesson $lessonId has ${questions.length} questions instead of $totalQuestions",
      );
    }

    for (var i = 0; i < questions.length; i++) {
      final question = questions[i];
      try {
        if (question['question'] == null ||
            question['question'].toString().isEmpty) {
          throw Exception("Question ${i + 1} has empty question text");
        }

        final options = question['options'];
        if (options == null || options.length < 2) {
          throw Exception("Question ${i + 1} has insufficient options");
        }

        final correctAnswer = question['correctAnswer'];
        if (correctAnswer == null || !options.contains(correctAnswer)) {
          throw Exception("Question ${i + 1} has invalid correct answer");
        }
      } catch (e) {
        throw Exception(
          "Lesson $lessonId, Question ${i + 1} validation failed: ${e.toString()}",
        );
      }
    }
  }

  /// Validates all lessons (for development/debugging purposes)
  static void validateAllLessons() {
    for (int i = 1; i <= totalLessons; i++) {
      try {
        validateLessonQuestions(i);
        debugPrint("Lesson $i questions validated successfully");
      } catch (e) {
        debugPrint("Validation failed for lesson $i: ${e.toString()}");
      }
    }
  }

  /// Gets the correct answer for a specific question
  static String getCorrectAnswer({
    required int lessonId,
    required int questionIndex,
    required List<Map<String, dynamic>> currentQuestions,
  }) {
    if (questionIndex < 0 || questionIndex >= currentQuestions.length) {
      throw Exception("Invalid question index: $questionIndex");
    }
    return currentQuestions[questionIndex]['correctAnswer'];
  }

  /// Calculates the score based on user answers
  static int calculateScore({
    required List<String?> userAnswers,
    required List<Map<String, dynamic>> questions,
  }) {
    if (userAnswers.length != questions.length) {
      throw Exception("User answers length doesn't match questions length");
    }

    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['correctAnswer']) {
        score++;
      }
    }
    return score;
  }
}
