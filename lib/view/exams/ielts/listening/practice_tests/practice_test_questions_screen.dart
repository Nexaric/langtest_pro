import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/controller/listening/listening_controller.dart';
import 'package:langtest_pro/core/loading/internet_signel_low.dart';
import 'package:langtest_pro/core/loading/loader_screen.dart';
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
  // Audio player state
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isSeeking = false;
  bool _isReloading = false;
  late String _audioPath;

  // Test state
  bool _isLoading = true;
  bool _isInitialized = false;
  String? _errorMessage;
  late List<Map<String, dynamic>> _currentQuestions;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showQuestions = false;
  int _score = 0;

  // Timer
  late PracticeTestTimer _testTimer;

  // Color scheme from audio_screen.dart
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);

  // Test configuration
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

  @override
  void initState() {
    super.initState();
    Get.put(ListeningProgressController());
    _audioPlayer = AudioPlayer();
    _testTimer = PracticeTestTimer(
      initialDuration:
          _partDurations[widget.part] ?? const Duration(minutes: 5),
      onTimeExpired: _handleTimeExpired,
      onTick: (remaining) => setState(() {}),
    );
    _initializeTest();
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
      });
    } catch (e) {
      debugPrint("Error initializing test: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load test: ${e.toString()}";
      });
    }
  }

  void _handleTimeExpired() {
    final unlockedNextPart = _isNextPartUnlocked(widget.part, _score);
    if (unlockedNextPart) {
      Get.find<ListeningProgressController>().completePracticeTest(widget.part);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => PracticeTestResultScreen(
              score: _score,
              totalQuestions: _currentQuestions.length,
              unlockedNextPart: unlockedNextPart,
              timeExpired: true,
            ),
      ),
    );
  }

  Future<String> _getAudioPathForPart(String part) async {
    final audioPaths = {
      'Part 1': await fetchAudioFromSupabase('practice_test/part1.mp3'),
      'Part 2': await fetchAudioFromSupabase('practice_test/part2.mp3'),
      'Part 3': await fetchAudioFromSupabase('practice_test/part3.mp3'),
      'Part 4': await fetchAudioFromSupabase('practice_test/part4.mp3'),
    };
    return audioPaths[part]!;
  }

  Future<String> fetchAudioFromSupabase(String supabasePath) async {
    try {
      // Download file bytes from Supabase
      final bytes = await Supabase.instance.client.storage
          .from('audio') // your bucket name
          .download(supabasePath); // e.g., 'folder/filename.mp3'

      // Prepare to store the file locally
      final dir = await getTemporaryDirectory();
      final fileName = supabasePath.split('/').last;
      final file = File('${dir.path}/$fileName');

      // Write bytes to the file
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
          part1.questions[0]['allQuestions'] as List<Map<String, dynamic>>,
      'Part 2':
          part2.questions[0]['allQuestions'] as List<Map<String, dynamic>>,
      'Part 3':
          part3.questions[0]['allQuestions'] as List<Map<String, dynamic>>,
      'Part 4':
          part4.questions[0]['allQuestions'] as List<Map<String, dynamic>>,
    };

    final requirements = _partRequirements[part]!;
    final allQuestionsForPart = List<Map<String, dynamic>>.from(
      allQuestions[part] ?? [],
    );

    if (allQuestionsForPart.length < requirements['selectQuestions']!) {
      throw Exception('Not enough questions available for $part');
    }

    final shuffled = List<Map<String, dynamic>>.from(allQuestionsForPart)
      ..shuffle(Random());
    return shuffled.take(requirements['selectQuestions']!).toList();
  }

  Future<void> _setupAudioPlayer() async {
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
          }
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });

    await _audioPlayer.setSource(DeviceFileSource(_audioPath));
  }

  Future<void> _reloadAudio() async {
    if (_isReloading) return;

    setState(() => _isReloading = true);
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(DeviceFileSource(_audioPath));
      await _audioPlayer.seek(Duration.zero);
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

  void _nextQuestion() {
    if (_testTimer.remainingTime.inSeconds <= 0) return;

    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      final unlockedNextPart = _isNextPartUnlocked(widget.part, _score);
      if (unlockedNextPart) {
        Get.find<ListeningProgressController>().completePracticeTest(
          widget.part,
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PracticeTestResultScreen(
                score: _score,
                totalQuestions: _currentQuestions.length,
                unlockedNextPart: unlockedNextPart,
                timeExpired: false,
              ),
        ),
      );
    }
  }

  bool _isNextPartUnlocked(String part, int score) {
    final requirements = {
      'Part 1': 6,
      'Part 2': 10,
      'Part 3': 15,
      'Part 4': 20,
    };

    return score >= (requirements[part] ?? 0);
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
    if (_isLoading) {
      return const Scaffold(body: LoaderScreen());
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "IELTS Listening ${widget.part}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: _gradientStart,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: InternetSignalLow(
          message: _errorMessage!,
          onRetry: _initializeTest,
        ),
      );
    }

    final currentQuestion = _currentQuestions[_currentQuestionIndex];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "IELTS Listening ${widget.part}",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _gradientStart,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Obx(() {
                final controller = Get.find<ListeningProgressController>();
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
            if (!_showQuestions) _buildAudioPlayerSection(screenWidth),
            if (_showQuestions) _buildQuestionsSection(currentQuestion),
            if (_testTimer.remainingTime.inSeconds <= 0)
              _buildTimeExpiredOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPlayerSection(double screenWidth) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeIn(
                child: Container(
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.headphones,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "IELTS Listening ${widget.part}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _getPartDescription(widget.part),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${_partRequirements[widget.part]!['selectQuestions']} Questions | ${_partDurations[widget.part]!.inMinutes} min",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildProgressControls(),
              const SizedBox(height: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _testTimer.formatDuration(_position),
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
              Text(
                _testTimer.formatDuration(_duration),
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
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
          icon: const Icon(Icons.replay_10, size: 32),
          color: Colors.white,
          onPressed: _skipBackward,
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: _playPause,
          child: Container(
            width: 70,
            height: 70,
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
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.forward_10, size: 32),
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF957DCD), Color(0xFF523D7F)],
                  ),
                ),
                child: const Icon(
                  Icons.headphones,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Now Playing",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      "IELTS Listening ${widget.part}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
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
                  size: 20,
                ),
                onPressed: _playPause,
              ),
              _isReloading
                  ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                  : IconButton(
                    icon: const Icon(
                      Icons.replay,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: _reloadAudio,
                  ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMiniProgressBar(),
        ],
      ),
    );
  }

  Widget _buildMiniProgressBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _testTimer.formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                _testTimer.formatDuration(_duration),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (_currentQuestionIndex > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex--;
                      _selectedAnswer = null;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentQuestion["question"],
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 20),
          ...currentQuestion["options"].map(
            (option) => _buildOptionButton(option),
          ),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child:
                  _selectedAnswer == option
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withOpacity(0.5)),
                ),
                elevation: 0,
              ),
              child: Text(
                "Back",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (_currentQuestionIndex > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed:
                _selectedAnswer != null &&
                        _testTimer.remainingTime.inSeconds > 0
                    ? _nextQuestion
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              _currentQuestionIndex < _currentQuestions.length - 1
                  ? "Next"
                  : "Finish",
              style: GoogleFonts.poppins(
                fontSize: 14,
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
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_off, size: 60, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                "Time's Up!",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "The test has ended because time expired.",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final unlockedNextPart = _isNextPartUnlocked(
                    widget.part,
                    _score,
                  );
                  if (unlockedNextPart) {
                    Get.find<ListeningProgressController>()
                        .completePracticeTest(widget.part);
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PracticeTestResultScreen(
                            score: _score,
                            totalQuestions: _currentQuestions.length,
                            unlockedNextPart: unlockedNextPart,
                            timeExpired: true,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "View Results",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: _gradientStart,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
