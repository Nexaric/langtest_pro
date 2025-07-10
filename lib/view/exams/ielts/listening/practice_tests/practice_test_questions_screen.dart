import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/listening_controller.dart';
import 'package:langtest_pro/core/loading/internet_signel_low.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'practice_test_result.dart';
import 'practice_test_timer.dart';
import 'questions/part_1.dart' as part1;
import 'questions/part_2.dart' as part2;
import 'questions/part_3.dart' as part3;
import 'questions/part_4.dart' as part4;

class PracticeTestQuestionsScreen extends StatefulWidget {
  final String part;

  const PracticeTestQuestionsScreen({required this.part, super.key});

  @override
  State<PracticeTestQuestionsScreen> createState() =>
      _PracticeTestQuestionsScreenState();
}

class _PracticeTestQuestionsScreenState
    extends State<PracticeTestQuestionsScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isSeeking = false;
  bool _isReloading = false;
  String? _audioPath;
  bool _isAudioLoading = true;
  bool _isLoading = true;
  bool _isInitialized = false;
  String? _errorMessage;
  late List<Map<String, dynamic>> _currentQuestions;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showQuestions = false;
  int _score = 0;

  late PracticeTestTimer _testTimer;

  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);

  static const _partDurations = {
    'Part 1': Duration(minutes: 5),
    'Part 2': Duration(minutes: 10),
    'Part 3': Duration(minutes: 15),
    'Part 4': Duration(minutes: 20),
  };

  static const _partRequirements = {
    'Part 1': {
      'totalQuestions': 30,
      'selectQuestions': 15,
      'requiredCorrect': 6,
    },
    'Part 2': {
      'totalQuestions': 35,
      'selectQuestions': 20,
      'requiredCorrect': 10,
    },
    'Part 3': {
      'totalQuestions': 40,
      'selectQuestions': 25,
      'requiredCorrect': 15,
    },
    'Part 4': {
      'totalQuestions': 50,
      'selectQuestions': 30,
      'requiredCorrect': 20,
    },
  };

  int _getLessonIdFromPart(String part) {
    switch (part) {
      case 'Part 1':
        return 1;
      case 'Part 2':
        return 2;
      case 'Part 3':
        return 3;
      case 'Part 4':
        return 4;
      default:
        throw Exception('Invalid part: $part');
    }
  }

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ListeningController>()) {
      Get.put(ListeningController());
    }
    final progressController = Get.find<ListeningController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      progressController.refreshProgress();
    });
    _audioPlayer = AudioPlayer();
    _testTimer = PracticeTestTimer(
      initialDuration:
          _partDurations[widget.part] ?? const Duration(minutes: 5),
      onTimeExpired: _handleTimeExpired,
      onTick: (remaining) => setState(() {}),
    );
    _initializeTest();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isInitialized) {
        progressController.markPracticeTestAsStarted(
          _getLessonIdFromPart(widget.part),
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _testTimer.dispose();
    super.dispose();
  }

  Future<void> _initializeTest() async {
    try {
      _audioPath = await _getAudioPathForPart(widget.part);
      _currentQuestions = _getRandomQuestionsForPart(widget.part);

      await _setupAudioPlayer();

      setState(() {
        _isLoading = false;
        _isInitialized = true;
        _isAudioLoading = false;
      });
    } catch (e) {
      debugPrint("Error initializing test: $e");
      setState(() {
        _isLoading = false;
        _isAudioLoading = false;
        _errorMessage = "Failed to load test: ${e.toString()}";
      });
    }
  }

  void _handleTimeExpired() {
    final lessonId = _getLessonIdFromPart(widget.part);
    final progressController = Get.find<ListeningController>();
    if (_score >= (_partRequirements[widget.part]!['requiredCorrect'] ?? 0)) {
      progressController.markPracticeTestAsCompleted(lessonId);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => PracticeTestResultScreen(
              score: _score,
              totalQuestions: _currentQuestions.length,
              unlockedNextPart:
                  _score >=
                  (_partRequirements[widget.part]!['requiredCorrect'] ?? 0),
              timeExpired: true,
              part: widget.part,
            ),
      ),
    );
  }

  Future<String> _getAudioPathForPart(String part) async {
    final audioPaths = {
      'Part 1': 'practice_test/part1.mp3',
      'Part 2': 'practice_test/part2.mp3',
      'Part 3': 'practice_test/part3.mp3',
      'Part 4': 'practice_test/part4.mp3',
    };
    if (!audioPaths.containsKey(part)) {
      throw Exception('Invalid part: $part');
    }
    return await fetchAudioFromSupabase(audioPaths[part]!);
  }

  Future<String> fetchAudioFromSupabase(String supabasePath) async {
    try {
      final bytes = await Supabase.instance.client.storage
          .from('audio')
          .download(supabasePath);
      final dir = await getTemporaryDirectory();
      final fileName = supabasePath.split('/').last;
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      debugPrint("Audio path: ${file.path}");
      return file.path;
    } catch (e) {
      debugPrint('Error fetching audio: $e');
      rethrow;
    }
  }

  List<Map<String, dynamic>> _getRandomQuestionsForPart(String part) {
    final allQuestions = {
      'Part 1':
          part1.questions.isNotEmpty
              ? part1.questions[0]['allQuestions']
                  as List<Map<String, dynamic>>?
              : [],
      'Part 2':
          part2.questions.isNotEmpty
              ? part2.questions[0]['allQuestions']
                  as List<Map<String, dynamic>>?
              : [],
      'Part 3':
          part3.questions.isNotEmpty
              ? part3.questions[0]['allQuestions']
                  as List<Map<String, dynamic>>?
              : [],
      'Part 4':
          part4.questions.isNotEmpty
              ? part4.questions[0]['allQuestions']
                  as List<Map<String, dynamic>>?
              : [],
    };

    final questions = allQuestions[part];
    if (questions == null || questions.isEmpty) {
      throw Exception('No questions available for $part');
    }

    final requirements = _partRequirements[part];
    if (requirements == null) {
      throw Exception('Invalid part: $part');
    }

    final selectQuestions = requirements['selectQuestions']!;
    if (questions.length < selectQuestions) {
      throw Exception(
        'Not enough questions for $part: ${questions.length} available, $selectQuestions required',
      );
    }

    final shuffled = List<Map<String, dynamic>>.from(questions)
      ..shuffle(Random());
    return shuffled.take(selectQuestions).toList();
  }

  Future<void> _setupAudioPlayer() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);

      _audioPlayer.onDurationChanged.listen((duration) {
        if (mounted) {
          setState(() {
            _duration = duration;
            if (_position > duration) _position = duration;
          });
        }
      });

      _audioPlayer.onPositionChanged.listen((position) {
        if (mounted && !_isSeeking) {
          setState(() => _position = position);
        }
      });

      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _showQuestions = true;
            _isPlaying = false;
            if (!_testTimer.isRunning) {
              _testTimer.start();
              Get.find<ListeningController>().markPracticeTestAsOpened(
                _getLessonIdFromPart(widget.part),
              );
            }
          });
        }
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state == PlayerState.playing);
        }
      });

      if (_audioPath != null) {
        await _audioPlayer.setSource(DeviceFileSource(_audioPath!));
      }
    } catch (e) {
      setState(() => _errorMessage = "Audio setup error: ${e.toString()}");
    }
  }

  Future<void> _reloadAudio() async {
    if (_isReloading || !_isInitialized) return;

    setState(() => _isReloading = true);
    try {
      await _audioPlayer.stop();
      if (_audioPath != null) {
        await _audioPlayer.setSource(DeviceFileSource(_audioPath!));
        await _audioPlayer.seek(Duration.zero);
      }
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
        _showQuestions = false;
        _testTimer.reset();
      });
    } catch (e) {
      setState(() => _errorMessage = "Reload error: ${e.toString()}");
    } finally {
      setState(() => _isReloading = false);
    }
  }

  Future<void> _playPause() async {
    if (!_isInitialized || _testTimer.remainingTime.inSeconds <= 0) return;

    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        if (_position >= _duration) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.resume();
      }
    } catch (e) {
      setState(() => _errorMessage = "Playback error: ${e.toString()}");
    }
  }

  Future<void> _skipForward() async {
    if (!_isInitialized || _testTimer.remainingTime.inSeconds <= 0) return;

    try {
      final newPosition = _position + const Duration(seconds: 10);
      final seekPosition = newPosition < _duration ? newPosition : _duration;

      setState(() => _isSeeking = true);
      await _audioPlayer.seek(seekPosition);
      setState(() {
        _position = seekPosition;
        _isSeeking = false;
      });

      if (!_isPlaying) await _audioPlayer.resume();
    } catch (e) {
      setState(() => _errorMessage = "Skip error: ${e.toString()}");
    }
  }

  Future<void> _skipBackward() async {
    if (!_isInitialized || _testTimer.remainingTime.inSeconds <= 0) return;

    try {
      final newPosition = _position - const Duration(seconds: 10);
      final seekPosition =
          newPosition > Duration.zero ? newPosition : Duration.zero;

      setState(() => _isSeeking = true);
      await _audioPlayer.seek(seekPosition);
      setState(() {
        _position = seekPosition;
        _isSeeking = false;
      });

      if (!_isPlaying) await _audioPlayer.resume();
    } catch (e) {
      setState(() => _errorMessage = "Skip error: ${e.toString()}");
    }
  }

  Future<void> _seekAudio(double value) async {
    if (!_isInitialized || _testTimer.remainingTime.inSeconds <= 0) return;

    try {
      final newPosition = Duration(seconds: value.toInt());
      setState(() {
        _position = newPosition;
        _isSeeking = true;
      });

      await _audioPlayer.seek(newPosition);
      setState(() => _isSeeking = false);

      if (_isPlaying) await _audioPlayer.resume();
    } catch (e) {
      setState(() => _errorMessage = "Seek error: ${e.toString()}");
    }
  }

  void _onAnswerSelected(String answer) {
    if (_testTimer.remainingTime.inSeconds <= 0) return;

    setState(() {
      _selectedAnswer = answer;
      if (answer == _currentQuestions[_currentQuestionIndex]["correctAnswer"]) {
        _score++;
      }
    });
  }

  void _nextQuestion() async {
    if (_testTimer.remainingTime.inSeconds <= 0) return;

    final lessonId = _getLessonIdFromPart(widget.part);
    final progressController = Get.find<ListeningController>();

    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      final isCompleted =
          _score >= (_partRequirements[widget.part]!['requiredCorrect'] ?? 0);
      if (isCompleted) {
        await progressController.markPracticeTestAsCompleted(lessonId);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PracticeTestResultScreen(
                score: _score,
                totalQuestions: _currentQuestions.length,
                unlockedNextPart: isCompleted,
                timeExpired: false,
                part: widget.part,
              ),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isAudioLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: _gradientStart)),
      );
    }

    if (_errorMessage != null) {
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
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: InternetSignalLow(
          message: _errorMessage!,
          onRetry: _initializeTest,
        ),
      );
    }

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
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Obx(() {
                final controller = Get.find<ListeningController>();
                return TimerDisplay(
                  duration: _testTimer.remainingTime,
                  isWarning: _testTimer.remainingTime.inMinutes < 1,
                );
              }),
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
            if (_testTimer.remainingTime.inSeconds <= 0)
              _buildTimeExpiredOverlay(),
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
                        "${_partRequirements[widget.part]!['selectQuestions']} Questions | ${_partDurations[widget.part]!.inMinutes} min",
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
                _testTimer.formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              Text(
                _testTimer.formatDuration(_duration),
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
              value: _position.inSeconds.toDouble().clamp(
                0.0,
                _duration.inSeconds.toDouble(),
              ),
              min: 0.0,
              max:
                  _duration.inSeconds > 0
                      ? _duration.inSeconds.toDouble()
                      : 1.0,
              onChangeStart: (value) => setState(() => _isSeeking = true),
              onChangeEnd: (value) => _seekAudio(value),
              onChanged:
                  (value) => setState(
                    () => _position = Duration(seconds: value.toInt()),
                  ),
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
          onPressed: _skipBackward,
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: _playPause,
          child: Container(
            width: 70.w,
            height: 70.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
          onPressed: _skipForward,
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
                  onPressed: _playPause,
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
                      onPressed: _reloadAudio,
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
                _testTimer.formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                _testTimer.formatDuration(_duration),
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
              value: _position.inSeconds.toDouble().clamp(
                0.0,
                _duration.inSeconds.toDouble(),
              ),
              min: 0.0,
              max:
                  _duration.inSeconds > 0
                      ? _duration.inSeconds.toDouble()
                      : 1.0,
              onChangeStart: (value) => setState(() => _isSeeking = true),
              onChangeEnd: (value) => _seekAudio(value),
              onChanged:
                  (value) => setState(
                    () => _position = Duration(seconds: value.toInt()),
                  ),
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
            ...(currentQuestion["options"] as List<dynamic>?)
                    ?.map((option) => _buildOptionButton(option as String))
                    .toList() ??
                [],
            SizedBox(height: 24.h),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return GestureDetector(
      onTap:
          _selectedAnswer == null && _testTimer.remainingTime.inSeconds > 0
              ? () => _onAnswerSelected(option)
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          color:
              _selectedAnswer == option
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
              child:
                  _selectedAnswer == option
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
            onPressed:
                _selectedAnswer != null &&
                        _testTimer.remainingTime.inSeconds > 0
                    ? _nextQuestion
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

  Widget _buildTimeExpiredOverlay() {
    return Positioned.fill(
      child: FadeIn(
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_off, size: 60.sp, color: Colors.red),
                SizedBox(height: 20.h),
                Text(
                  "Time's Up!",
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "The test has ended because time expired.",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    final lessonId = _getLessonIdFromPart(widget.part);
                    final progressController = Get.find<ListeningController>();
                    if (_score >=
                        (_partRequirements[widget.part]!['requiredCorrect'] ??
                            0)) {
                      progressController.markPracticeTestAsCompleted(lessonId);
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PracticeTestResultScreen(
                              score: _score,
                              totalQuestions: _currentQuestions.length,
                              unlockedNextPart:
                                  _score >=
                                  (_partRequirements[widget
                                          .part]!['requiredCorrect'] ??
                                      0),
                              timeExpired: true,
                              part: widget.part,
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "View Results",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: _gradientStart,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
