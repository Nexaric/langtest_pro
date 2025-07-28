import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PracticeTestQuestionsScreen extends StatefulWidget {
  final String part;

  const PracticeTestQuestionsScreen({required this.part, super.key});

  @override
  State<PracticeTestQuestionsScreen> createState() =>
      _PracticeTestQuestionsScreenState();
}

class _PracticeTestQuestionsScreenState
    extends State<PracticeTestQuestionsScreen> {
  // Mock data for the UI
  bool _isPlaying = false;
  Duration _duration = const Duration(minutes: 4, seconds: 30);
  Duration _position = const Duration(minutes: 1, seconds: 45);
  bool _showQuestions = false;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  int _score = 0;
  bool _isAudioLoading = false;
  bool _isReloading = false;

  // Mock questions data
  final List<Map<String, dynamic>> _currentQuestions = [
    {
      "question": "What is the main topic of the conversation?",
      "options": [
        "University accommodation",
        "Campus facilities",
        "Student clubs",
        "Lecture schedules"
      ],
      "correctAnswer": "University accommodation"
    },
    {
      "question": "Where is the student from?",
      "options": ["Canada", "Australia", "India", "Brazil"],
      "correctAnswer": "Canada"
    },
    {
      "question": "What type of room does the student prefer?",
      "options": [
        "Single room",
        "Shared apartment",
        "Dormitory",
        "Studio flat"
      ],
      "correctAnswer": "Shared apartment"
    }
  ];

  // Color scheme
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);
  final Color _accentColor = const Color(0xFF00BFA6);

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _currentQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IELTS Listening ${widget.part}",
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _gradientStart,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: TimerDisplay(
                duration: const Duration(minutes: 4, seconds: 15),
                isWarning: false,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            if (!_showQuestions) _buildAudioPlayerSection(),
            if (_showQuestions) _buildQuestionsSection(currentQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerSection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeIn(
                child: Container(
                  width: 0.8.sw,
                  height: 0.8.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.headphones, size: 80.sp, color: Colors.white),
                      SizedBox(height: 20.h),
                      Text(
                        "IELTS Listening ${widget.part}",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _getPartDescription(widget.part),
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "15 Questions | 5 min",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              _buildProgressControls(),
              SizedBox(height: 20.h),
              _buildPlaybackControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressControls() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
            ),
            child: Slider(
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _position = Duration(seconds: value.toInt());
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.replay_10, size: 32.sp),
          color: Colors.white,
          onPressed: () {},
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: () {
            setState(() {
              _isPlaying = !_isPlaying;
              if (!_showQuestions && _isPlaying) {
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    _showQuestions = true;
                  });
                });
              }
            });
          },
          child: Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36.sp,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 20.w),
        IconButton(
          icon: Icon(Icons.forward_10, size: 32.sp),
          color: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildQuestionsSection(Map<String, dynamic> currentQuestion) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [_buildMiniPlayer(), _buildQuestionCard(currentQuestion)],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return FadeIn(
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
                    ),
                  ),
                  child: Icon(
                    Icons.headphones,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Now Playing",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        "IELTS Listening ${widget.part}",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
                _isReloading
                    ? Padding(
                        padding: EdgeInsets.all(8.w),
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.replay,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        onPressed: () {},
                      ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildMiniProgressBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniProgressBar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            ),
            child: Slider(
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _position = Duration(seconds: value.toInt());
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> currentQuestion) {
    return FadeIn(
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_currentQuestions.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (_currentQuestionIndex > 0)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex--;
                        _selectedAnswer = null;
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              currentQuestion["question"] ?? "Loading question...",
              style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white),
            ),
            SizedBox(height: 20.h),
            ...(currentQuestion["options"] as List<dynamic>)
                .map((option) => _buildOptionButton(option as String))
                .toList(),
            SizedBox(height: 24.h),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return GestureDetector(
      onTap: _selectedAnswer == null
          ? () {
              setState(() {
                _selectedAnswer = option;
                if (option ==
                    _currentQuestions[_currentQuestionIndex]["correctAnswer"]) {
                  _score++;
                }
              });
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          color: _selectedAnswer == option
              ? Colors.amber.withOpacity(0.3)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: _selectedAnswer == option
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentQuestionIndex > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex--;
                  _selectedAnswer = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: Colors.white.withOpacity(0.5)),
                ),
                elevation: 0,
              ),
              child: Text(
                "Back",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (_currentQuestionIndex > 0) SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedAnswer != null
                ? () {
                    if (_currentQuestionIndex < _currentQuestions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = null;
                      });
                    } else {
                      // Handle test completion
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 5,
            ),
            child: Text(
              _currentQuestionIndex < _currentQuestions.length - 1
                  ? "Next"
                  : "Finish",
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: _gradientStart,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getPartDescription(String part) {
    switch (part) {
      case "Part 1":
        return "Conversation between two people in a social context";
      case "Part 2":
        return "Monologue in a social context (e.g., speech)";
      case "Part 3":
        return "Conversation between multiple people in an educational context";
      case "Part 4":
        return "Academic lecture or talk";
      default:
        return "IELTS Listening Practice";
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final bool isWarning;

  const TimerDisplay({
    required this.duration,
    required this.isWarning,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      "$minutes:$seconds",
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: isWarning ? Colors.red : Colors.white,
      ),
    );
  }
}