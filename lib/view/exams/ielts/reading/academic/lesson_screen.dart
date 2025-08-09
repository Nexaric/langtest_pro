import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/lessons/academic_result.dart';
import 'package:langtest_pro/view/exams/ielts/reading/academic/academic_lessons.dart';
import 'lessons/academic_lesson_1.dart' as lesson1;
import 'lessons/academic_lesson_2.dart' as lesson2;
import 'lessons/academic_lesson_3.dart' as lesson3;
import 'lessons/academic_lesson_4.dart' as lesson4;
import 'lessons/academic_lesson_5.dart' as lesson5;
import 'lessons/academic_lesson_6.dart' as lesson6;
import 'lessons/academic_lesson_7.dart' as lesson7;
import 'lessons/academic_lesson_8.dart' as lesson8;
import 'lessons/academic_lesson_9.dart' as lesson9;
import 'lessons/academic_lesson_10.dart' as lesson10;
import 'lessons/academic_lesson_11.dart' as lesson11;
import 'lessons/academic_lesson_12.dart' as lesson12;
import 'lessons/academic_lesson_13.dart' as lesson13;
import 'lessons/academic_lesson_14.dart' as lesson14;
import 'lessons/academic_lesson_15.dart' as lesson15;
import 'lessons/academic_lesson_16.dart' as lesson16;
import 'lessons/academic_lesson_17.dart' as lesson17;
import 'lessons/academic_lesson_18.dart' as lesson18;
import 'lessons/academic_lesson_19.dart' as lesson19;
import 'lessons/academic_lesson_20.dart' as lesson20;
import 'lessons/academic_lesson_21.dart' as lesson21;
import 'lessons/academic_lesson_22.dart' as lesson22;
import 'lessons/academic_lesson_23.dart' as lesson23;
import 'lessons/academic_lesson_24.dart' as lesson24;
import 'lessons/academic_lesson_25.dart' as lesson25;
import 'lessons/academic_lesson_26.dart' as lesson26;
import 'lessons/academic_lesson_27.dart' as lesson27;
import 'lessons/academic_lesson_28.dart' as lesson28;
import 'lessons/academic_lesson_29.dart' as lesson29;
import 'lessons/academic_lesson_30.dart' as lesson30;
import 'lessons/academic_lesson_31.dart' as lesson31;
import 'lessons/academic_lesson_32.dart' as lesson32;
import 'lessons/academic_lesson_33.dart' as lesson33;
import 'lessons/academic_lesson_34.dart' as lesson34;
import 'lessons/academic_lesson_35.dart' as lesson35;
import 'lessons/academic_lesson_36.dart' as lesson36;
import 'lessons/academic_lesson_37.dart' as lesson37;
import 'lessons/academic_lesson_38.dart' as lesson38;
import 'lessons/academic_lesson_39.dart' as lesson39;
import 'lessons/academic_lesson_40.dart' as lesson40;

class CustomBeveledBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
        topRight: const Radius.circular(10),
        bottomLeft: const Radius.circular(10),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class LessonScreen extends StatefulWidget {
  final int lessonId;


  const LessonScreen({
    super.key,
    required this.lessonId,
   
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _isBold = false;
  int _fontSizeIndex = 0;
  final List<double> _fontSizes = [15.0, 18.0, 21.0];
  bool _isQuestionScreen = false;
  bool _isDarkMode = false;
  late Map<String, dynamic> lessonData;
  late List<Map<String, dynamic>> selectedQuestions;
  int _currentQuestionIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _questionScrollController = ScrollController();

  final Map<String, Color> _lightColors = {
    'gradientStart': const Color(0xFF4B0082),
    'gradientEnd': const Color(0xFF6A5ACD),
    'accent': const Color(0xFF00BFA6),
    'background': Colors.white,
    'textPrimary': Colors.black87,
    'textSecondary': Colors.black54,
    'card': const Color(0xFFF5F5FF),
    'cardAccent': const Color(0xFFE8E6FF),
  };

  final Map<String, Color> _darkColors = {
    'gradientStart': const Color(0xFF2A2878),
    'gradientEnd': const Color(0xFF3F3A8C),
    'accent': const Color(0xFF00BFA6),
    'background': Colors.black,
    'textPrimary': Colors.white,
    'textSecondary': Colors.white70,
    'card': const Color(0xFF3F3A8C),
    'cardAccent': const Color(0xFF4A40BF),
  };

  final List<Color> _magicGradient = [
    const Color(0xFF3E1E68),
    const Color.fromARGB(255, 84, 65, 228),
  ];

  final List<Color> _attractiveGradient = [
    const Color(0xFF00CED1),
    const Color(0xFF00CED1),
  ];

  @override
  void initState() {
    super.initState();
    // if (!Get.isRegistered<ReadingProgressController>()) {
    //   Get.put(ReadingProgressController());
    // }
    lessonData = _getLessonData();
    selectedQuestions = _getRandomQuestions();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll > 0) {
        // final progress = (currentScroll / maxScroll).clamp(0.0, 1.0) * 0.5;
        // Get.find<ReadingProgressController>().updateProgress(progress);
      }
    });
  }

  Map<String, dynamic> _getLessonData() {
    try {
      switch (widget.lessonId) {
        case 1:
          return lesson1.AcademicLesson1Data.data;
        case 2:
          return lesson2.AcademicLesson2Data.data;
        case 3:
          return lesson3.AcademicLesson3Data.data;
        case 4:
          return lesson4.AcademicLesson4Data.data;
        case 5:
          return lesson5.AcademicLesson5Data.data;
        case 6:
          return lesson6.AcademicLesson6Data.data;
        case 7:
          return lesson7.AcademicLesson7Data.data;
        case 8:
          return lesson8.AcademicLesson8Data.data;
        case 9:
          return lesson9.AcademicLesson9Data.data;
        case 10:
          return lesson10.AcademicLesson10Data.data;
        case 11:
          return lesson11.AcademicLesson11Data.data;
        case 12:
          return lesson12.AcademicLesson12Data.data;
        case 13:
          return lesson13.AcademicLesson13Data.data;
        case 14:
          return lesson14.AcademicLesson14Data.data;
        case 15:
          return lesson15.AcademicLesson15Data.data;
        case 16:
          return lesson16.AcademicLesson16Data.data;
        case 17:
          return lesson17.AcademicLesson17Data.data;
        case 18:
          return lesson18.AcademicLesson18Data.data;
        case 19:
          return lesson19.AcademicLesson19Data.data;
        case 20:
          return lesson20.AcademicLesson20Data.data;
        case 21:
          return lesson21.AcademicLesson21Data.data;
        case 22:
          return lesson22.AcademicLesson22Data.data;
        case 23:
          return lesson23.AcademicLesson23Data.data;
        case 24:
          return lesson24.AcademicLesson24Data.data;
        case 25:
          return lesson25.AcademicLesson25Data.data;
        case 26:
          return lesson26.AcademicLesson26Data.data;
        case 27:
          return lesson27.AcademicLesson27Data.data;
        case 28:
          return lesson28.AcademicLesson28Data.data;
        case 29:
          return lesson29.AcademicLesson29Data.data;
        case 30:
          return lesson30.AcademicLesson30Data.data;
        case 31:
          return lesson31.AcademicLesson31Data.data;
        case 32:
          return lesson32.AcademicLesson32Data.data;
        case 33:
          return lesson33.AcademicLesson33Data.data;
        case 34:
          return lesson34.AcademicLesson34Data.data;
        case 35:
          return lesson35.AcademicLesson35Data.data;
        case 36:
          return lesson36.AcademicLesson36Data.data;
        case 37:
          return lesson37.AcademicLesson37Data.data;
        case 38:
          return lesson38.AcademicLesson38Data.data;
        case 39:
          return lesson39.AcademicLesson39Data.data;
        case 40:
          return lesson40.AcademicLesson40Data.data;
        default:
          return _getPlaceholderLessonData();
      }
    } catch (e) {
      return _getPlaceholderLessonData();
    }
  }

  Map<String, dynamic> _getPlaceholderLessonData() {
    int totalQuestions;
    int questionsToAsk;
    int requiredCorrectAnswers;

    if (widget.lessonId <= 10) {
      totalQuestions = 20;
      questionsToAsk = 10;
      requiredCorrectAnswers = 5;
    } else if (widget.lessonId <= 20) {
      totalQuestions = 25;
      questionsToAsk = 15;
      requiredCorrectAnswers = 7;
    } else if (widget.lessonId <= 30) {
      totalQuestions = 30;
      questionsToAsk = 20;
      requiredCorrectAnswers = 10;
    } else {
      totalQuestions = 40;
      questionsToAsk = 25;
      requiredCorrectAnswers = 13;
    }

    return {
      'lessonId': widget.lessonId,
      'title': 'Lesson ${widget.lessonId}: Placeholder Topic',
      'passage':
          'This is a placeholder lesson. Please add actual content for Lesson ${widget.lessonId}.',
      'questions': List.generate(
        totalQuestions,
        (index) => {
          'question': 'Placeholder Question ${index + 1}',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option A',
          'selectedIndex': -1,
        },
      ),
      'questionsToAsk': questionsToAsk,
      'requiredCorrectAnswers': requiredCorrectAnswers,
    };
  }

  List<Map<String, dynamic>> _getRandomQuestions() {
    final random = Random();
    final questions = lessonData['questions'] as List<dynamic>? ?? [];
    int questionsToAsk;
    if (widget.lessonId <= 10) {
      questionsToAsk = 10;
    } else if (widget.lessonId <= 20) {
      questionsToAsk = 15;
    } else if (widget.lessonId <= 30) {
      questionsToAsk = 20;
    } else {
      questionsToAsk = 25;
    }
    questionsToAsk =
        (lessonData['questionsToAsk'] as int?)?.clamp(1, questions.length) ??
        questionsToAsk;

    final List<Map<String, dynamic>> shuffledQuestions =
        questions.isNotEmpty
            ? List.from(questions)
                .map(
                  (q) => {...Map<String, dynamic>.from(q), 'selectedIndex': -1},
                )
                .toList()
            : List.generate(
              questionsToAsk,
              (index) => {
                'question': 'Placeholder Question ${index + 1}',
                'options': ['Option A', 'Option B', 'Option C', 'Option D'],
                'correctAnswer': 'Option A',
                'selectedIndex': -1,
              },
            );
    shuffledQuestions.shuffle(random);
    return shuffledQuestions.take(questionsToAsk).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _questionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return _isQuestionScreen
        ? _buildQuestionScaffold()
        : _buildPassageScaffold();
  }

  Widget _buildPassageScaffold() {
    final colors = _isDarkMode ? _darkColors : _lightColors;
    final passageTextStyle = GoogleFonts.poppins(
      fontSize: _fontSizes[_fontSizeIndex],
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      height: 1.5,
      color: colors['textPrimary'],
    );

    return Scaffold(
      backgroundColor: colors['background'],
      appBar: AppBar(
        backgroundColor: colors['gradientStart'],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors['accent']),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AcademicLessonsScreen(),
              ),
            );
          },
        ),
        title: Text(
          lessonData['title'],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colors['textPrimary'],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: colors['accent'],
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
            tooltip: 'Toggle Light/Dark Mode',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors['gradientStart']!, colors['gradientEnd']!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: FadeInDown(
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors['card'],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors['textSecondary']!.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      colors['cardAccent']!.withOpacity(0.8),
                      colors['card']!.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBold = !_isBold;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              _isBold
                                  ? colors['accent']!.withOpacity(0.2)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isBold
                              ? Icons.format_bold
                              : Icons.format_bold_outlined,
                          color: colors['accent'],
                          size: 24,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _fontSizeIndex =
                              (_fontSizeIndex + 1) % _fontSizes.length;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors['textPrimary']!.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.text_fields,
                          color: colors['accent'],
                          size: 24,
                        ),
                      ),
                    ),
                    Text(
                      'Font: ${_fontSizes[_fontSizeIndex].toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors['textPrimary'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _buildPassageScreen(passageTextStyle, colors)),
        ],
      ),
    );
  }

  Widget _buildPassageScreen(
    TextStyle passageTextStyle,
    Map<String, Color> colors,
  ) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...lessonData['passage']
                      .toString()
                      .split('\n')
                      .asMap()
                      .entries
                      .where((entry) => entry.value.trim().isNotEmpty)
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            '${entry.key + 1}. ${entry.value.trim()}',
                            style: passageTextStyle,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isQuestionScreen = true;
                      _currentQuestionIndex = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(1.0),
                    onEnd: () => setState(() {}),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _magicGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: _magicGradient.first.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    'Question ${_currentQuestionIndex + 1} of ${selectedQuestions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FadeIn(
                    child: _buildQuestionCard(_currentQuestionIndex),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _handleBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              colors: _attractiveGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: CustomBeveledBorder(),
                            shadows: [
                              BoxShadow(
                                color: _attractiveGradient.first.withOpacity(
                                  0.5,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Back',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            selectedQuestions[_currentQuestionIndex]['selectedIndex'] !=
                                    -1
                                ? _nextQuestion
                                : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              colors:
                                  selectedQuestions[_currentQuestionIndex]['selectedIndex'] !=
                                          -1
                                      ? _attractiveGradient
                                      : [
                                        Colors.grey.shade700,
                                        Colors.grey.shade500,
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: CustomBeveledBorder(),
                            shadows: [
                              BoxShadow(
                                color:
                                    selectedQuestions[_currentQuestionIndex]['selectedIndex'] !=
                                            -1
                                        ? _attractiveGradient.first.withOpacity(
                                          0.5,
                                        )
                                        : Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _currentQuestionIndex <
                                      selectedQuestions.length - 1
                                  ? 'Next'
                                  : 'Submit',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int questionIndex) {
    if (questionIndex >= selectedQuestions.length) {
      return const SizedBox.shrink();
    }
    final question = selectedQuestions[questionIndex];
    final isTrueFalse =
        question['options'].contains('TRUE') &&
        question['options'].contains('FALSE');
    final isParagraph = question['question'].toLowerCase().contains(
      'which paragraph',
    );
    final questionTypeLabel =
        isTrueFalse
            ? 'True/False/Not Given'
            : isParagraph
            ? 'Paragraph Identification'
            : 'Multiple Choice';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Scrollbar(
            controller: _questionScrollController,
            child: SingleChildScrollView(
              controller: _questionScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isTrueFalse
                            ? Icons.check_circle_outline
                            : isParagraph
                            ? Icons.format_list_numbered
                            : Icons.radio_button_checked,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        questionTypeLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${questionIndex + 1}. ${question['question']}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(question['options'].length, (optionIndex) {
                    bool isSelected = question['selectedIndex'] == optionIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedQuestions[questionIndex]['selectedIndex'] =
                              optionIndex;
                          final answered =
                              selectedQuestions
                                  .where((q) => q['selectedIndex'] != -1)
                                  .length;
                        
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected ? Colors.white : Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question['options'][optionIndex],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBack() {
    setState(() {
      if (_currentQuestionIndex == 0) {
        _isQuestionScreen = false;
      } else {
        _currentQuestionIndex--;
        _questionScrollController.jumpTo(0);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < selectedQuestions.length - 1) {
        _currentQuestionIndex++;
        _questionScrollController.jumpTo(0);
      } else {
        _submitAnswers();
      }
    });
  }

  void _submitAnswers() {
    int correctAnswers = _calculateScore();
    int totalQuestions = selectedQuestions.length;
    List<int> selectedAnswers =
        selectedQuestions.map((q) => q['selectedIndex'] as int).toList();

    final requiredCorrect =
        lessonData['requiredCorrectAnswers'] as int? ??
        (widget.lessonId <= 10
            ? 5
            : widget.lessonId <= 20
            ? 7
            : widget.lessonId <= 30
            ? 10
            : 13);
    if (correctAnswers >= requiredCorrect) {
      // Get.find<ReadingProgressController>().completeAcademicLesson(
      //   lessonId: widget.lessonId,
      //   score: '$correctAnswers/$totalQuestions',
      // );
      
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => AcademicResult(
              totalQuestions: totalQuestions,
              correctAnswers: correctAnswers,
              selectedAnswers: selectedAnswers,
              questions: selectedQuestions,
              
              lessonId: widget.lessonId,
            ),
      ),
    );
  }

  int _calculateScore() {
    int score = 0;
    for (var question in selectedQuestions) {
      if (question['selectedIndex'] >= 0 &&
          question['selectedIndex'] < question['options'].length &&
          question['options'][question['selectedIndex']] ==
              question['correctAnswer']) {
        score++;
      }
    }
    return score;
  }
}
