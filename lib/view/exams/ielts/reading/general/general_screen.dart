import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_result.dart';
import 'package:langtest_pro/view/exams/ielts/reading/general/general_lessons.dart';
import 'lessons/general_lesson_1.dart' as lesson1;

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

class GeneralScreen extends StatefulWidget {
  final int lessonId;
  final VoidCallback onComplete;

  const GeneralScreen({
    super.key,
    required this.lessonId,
    required this.onComplete,
  });

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
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
        final progress = (currentScroll / maxScroll).clamp(0.0, 1.0) * 0.5;
        // Get.find<ReadingProgressController>().updateProgress(progress);
      }
    });
  }

  Map<String, dynamic> _getLessonData() {
    try {
      switch (widget.lessonId) {
        case 1:
          return lesson1.GeneralSection1.data['lesson_1']!;
        default:
          return _getPlaceholderLessonData();
      }
    } catch (e) {
      return _getPlaceholderLessonData();
    }
  }

  Map<String, dynamic> _getPlaceholderLessonData() {
    int totalQuestions = 20;
    int questionsToAsk = 10;
    int requiredCorrectAnswers = 4;

    if (widget.lessonId > 5 && widget.lessonId <= 10) {
      questionsToAsk = 12;
      requiredCorrectAnswers = 5;
    } else if (widget.lessonId > 10) {
      questionsToAsk = 15;
      requiredCorrectAnswers = 6;
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
    int questionsToAsk = 10;
    if (widget.lessonId > 5 && widget.lessonId <= 10) {
      questionsToAsk = 12;
    } else if (widget.lessonId > 10) {
      questionsToAsk = 15;
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
  Widget build(BuildContext context) {
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
                builder: (context) => const GeneralLessonsScreen(),
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
                      colors['card']!.withOpacity(0.0),
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
                      'Font Size: ${_fontSizes[_fontSizeIndex].toInt()}',
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
                          // Get.find<ReadingProgressController>().updateProgress(
                          //   0.5 + (answered / selectedQuestions.length) * 0.5,
                          // );
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
        (widget.lessonId <= 5
            ? 4
            : widget.lessonId <= 10
            ? 5
            : 6);
    if (correctAnswers >= requiredCorrect) {
      // Get.find<ReadingProgressController>().completeGeneralLesson(
      //   lessonId: widget.lessonId,
      //   score: '$correctAnswers/$totalQuestions',
      // );
      widget.onComplete();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => GeneralResult(
              totalQuestions: totalQuestions,
              correctAnswers: correctAnswers,
              selectedAnswers: selectedAnswers,
              questions: selectedQuestions,
              onComplete: widget.onComplete,
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
