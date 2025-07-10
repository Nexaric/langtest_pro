import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langtest_pro/controller/writing_controller.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/lesson_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_screen.dart';

class LessonResult extends StatefulWidget {
  final int academicWordCount;
  final int generalWordCount;
  final int lessonNumber;
  final VoidCallback? onFinish;

  const LessonResult({
    super.key,
    required this.academicWordCount,
    required this.generalWordCount,
    required this.lessonNumber,
    this.onFinish,
  });

  @override
  State<LessonResult> createState() => _LessonResultState();
}

class _LessonResultState extends State<LessonResult>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _headerColorAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _headerColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.academicWordCount >= 150 ? Colors.teal[50] : Colors.amber[50],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getFeedback(int wordCount) {
    if (wordCount >= 150) {
      return 'Excellent! Your response exceeds the IELTS Writing Task 2 requirements.';
    } else if (wordCount >= 100) {
      return 'Good effort! You\'re close to the 150-word target for IELTS.';
    } else {
      return 'Keep practicing! Aim for at least 150 words to fully address the task.';
    }
  }

  String _getSubFeedback(int wordCount) {
    if (wordCount >= 150) {
      return 'You\'ve demonstrated strong writing skills.';
    } else if (wordCount >= 100) {
      return 'Try adding more examples or explanations.';
    } else {
      return 'Consider expanding your ideas with more details.';
    }
  }

  double _getProgress(int wordCount) {
    return (wordCount / 150).clamp(0.0, 1.0);
  }

  Widget _buildProgressIndicator(int wordCount, String label) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progress = _getProgress(wordCount) * _progressAnimation.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  '$wordCount words',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuart,
                  width: MediaQuery.of(context).size.width * 0.9 * progress,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          wordCount >= 150
                              ? [Colors.teal[400]!, Colors.teal[600]!]
                              : [Colors.amber[400]!, Colors.amber[600]!],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: (wordCount >= 150 ? Colors.teal : Colors.amber)
                            .withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${(progress * 100).round()}% of target',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  'Goal: 150 words',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreCircle(int wordCount, String label) {
    final progress = _getProgress(wordCount);
    final color = wordCount >= 150 ? Colors.teal : Colors.amber;
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.2), width: 8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: progress * _progressAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wordCount.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4, right: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.blue[400],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLessonScreen(int lessonNumber) {
    if (lessonNumber >= 1 && lessonNumber <= 40) {
      return WritingScreen(lessonNumber: lessonNumber);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lesson $lessonNumber",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text(
          "Lesson $lessonNumber content not found",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.academicWordCount >= 150;
    final isLastLesson = widget.lessonNumber == 40;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        cardTheme: theme.cardTheme.copyWith(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Lesson ${widget.lessonNumber} Results',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _headerColorAnimation,
                    builder: (context, child) {
                      return Card(
                        color: _headerColorAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                isSuccess
                                    ? Icons.celebration
                                    : Icons.auto_awesome,
                                size: 36,
                                color:
                                    isSuccess
                                        ? Colors.teal[600]
                                        : Colors.amber[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isSuccess ? 'Great Work!' : 'Keep Practicing!',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getFeedback(widget.academicWordCount),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _getSubFeedback(widget.academicWordCount),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreCircle(widget.academicWordCount, 'Academic'),
                      if (widget.generalWordCount > 0)
                        _buildScoreCircle(widget.generalWordCount, 'General'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildProgressSection(),
                  if (widget.academicWordCount < 150) _buildTipsSection(),
                  const SizedBox(height: 16),
                  _buildActionButtons(isLastLesson),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Writing Progress',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your progress toward IELTS writing goals',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 12),
            _buildProgressIndicator(
              widget.academicWordCount,
              'Academic Writing',
            ),
            if (widget.generalWordCount > 0) ...[
              const SizedBox(height: 12),
              _buildProgressIndicator(
                widget.generalWordCount,
                'General Writing',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue[400]),
                const SizedBox(width: 6),
                Text(
                  'Quick Tips',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              'Add examples',
              'Support each main point with a specific example',
            ),
            _buildTipItem(
              'Explain fully',
              'Don\'t assume the reader knows what you mean',
            ),
            _buildTipItem(
              'Use transitions',
              'Words like “however” and “furthermore” add length',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isLastLesson) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => _getLessonScreen(widget.lessonNumber),
                ),
              );
            },
            child: Text(
              'Review Again',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.blue[600],
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: BorderSide(color: Colors.blue[200]!, width: 1),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              final controller = Get.find<WritingController>();
              controller.completeLesson(widget.lessonNumber);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          isLastLesson
                              ? const LessonListScreen()
                              : _getLessonScreen(widget.lessonNumber + 1),
                ),
              );
            },
            child: Text(
              isLastLesson ? 'Back to Lessons' : 'Next Lesson',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
