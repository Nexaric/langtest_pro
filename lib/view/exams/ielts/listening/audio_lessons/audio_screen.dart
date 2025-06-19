// lib/exams/ielts/listening/audio_lessons/audio_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/core/loading/internet_signel_low.dart';
import 'package:langtest_pro/core/loading/loader_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'audio_result.dart';
import 'questions/question_manager.dart';
import '../../../../../controller/listening_progress_provider.dart';

class AudioScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final VoidCallback onComplete;
  final Function(double)? onProgressUpdate;

  const AudioScreen({
    required this.lesson,
    required this.onComplete,
    this.onProgressUpdate,
    super.key,
  });

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool _isAudioLoading = true;
  String audioUrl = '';
  late String audioPath = '';
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool showQuestions = false;
  int _score = 0;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSeeking = false;
  bool _isInitialized = false;
  bool _isReloading = false;
  bool _isTransitioning = false;
  List<Map<String, dynamic>> _currentQuestions = [];
  List<String?> _userAnswers = [];

  // Gradient colors for full-screen background
  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);

  // String get audioFilePath => 'audio/lesson${widget.lesson["lessonId"]}.mp3';

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  void _loadQuestions() {
    final lessonId = widget.lesson["lessonId"];
    setState(() {
      _currentQuestions = QuestionManager.getQuestionsForLesson(lessonId);
      _userAnswers = List<String?>.filled(_currentQuestions.length, null);
    });
  }

  Future<void> _loadAudio() async {
    await fetchAudioFromSupabase(
      'lesson${widget.lesson["lessonId"]}.mp3',
    );
    _initAudio();
    _loadQuestions();
  }



Future<void> fetchAudioFromSupabase(String firebasePath) async {
  try {
    debugPrint('Fetching audio from Supabase: $firebasePath');
    final response = await Supabase.instance.client.storage
        .from('audio')
        .download(firebasePath);

    // Save the response (bytes) to a temp file
    final bytes = response;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${firebasePath.split('/').last}');
    await file.writeAsBytes(bytes);

    setState(() {
      audioPath = file.path; // Use this path in your audio player
      _isAudioLoading = false;
    });
  } catch (e) {
    print('Error fetching audio: $e');
    setState(() {
      _isAudioLoading = false;
    });
    rethrow;
  }
}


  Future<void> _initAudio() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _setupAudioListeners();

      await _audioPlayer.setSource(DeviceFileSource(audioPath));

      setState(() {
        _isLoading = false;
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load audio: ${e.toString()}";
      });
      debugPrint("Audio loading error: $e");
    }
  }

  Future<void> _reloadAudio() async {
    if (_isReloading) return;

    setState(() => _isReloading = true);
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(DeviceFileSource(audioPath));
      await _audioPlayer.seek(Duration.zero);
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    } catch (e) {
      setState(() => _errorMessage = "Reload error: ${e.toString()}");
    } finally {
      setState(() => _isReloading = false);
    }
  }

  void _setupAudioListeners() {
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

        if (_duration.inMilliseconds > 0) {
          final progress = position.inMilliseconds / _duration.inMilliseconds;
          widget.onProgressUpdate?.call(progress);
        }
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isTransitioning = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              showQuestions = widget.lesson["lessonId"] != 1;
              _isPlaying = false;
              _isTransitioning = false;
              if (widget.lesson["lessonId"] == 1) {
                final progressController =
                    Get.find<ListeningProgressController>();
                progressController.completeLesson();
                widget.onComplete();
                Navigator.pop(context);
              }
            });
          }
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });
  }

  Future<void> _playPause() async {
    if (!_isInitialized) return;

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
    if (!_isInitialized) return;

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
    if (!_isInitialized) return;

    try {
      final newPosition = _position - const Duration(seconds: 10);
      final seekPosition =
          newPosition >= Duration.zero ? newPosition : Duration.zero;

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
    if (!_isInitialized) return;

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
    setState(() {
      _selectedAnswer = answer;
      _userAnswers[_currentQuestionIndex] = answer;
      if (answer == _currentQuestions[_currentQuestionIndex]["correctAnswer"]) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _currentQuestions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      } else {
        final correctAnswers = _score;
        final wrongAnswers = _currentQuestions.length - _score;
        final lessonId = widget.lesson["lessonId"];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AudioResultScreen(
                  score: _score,
                  totalQuestions: _currentQuestions.length,
                  correctAnswers: correctAnswers,
                  wrongAnswers: wrongAnswers,
                  lessonId: lessonId,
                  onComplete: () {
                    if (QuestionManager.isLessonPassed(_score, lessonId)) {
                      final progressController =
                          Get.find<ListeningProgressController>();
                      progressController.completeLesson();
                      widget.onComplete();
                    }
                  },
                ),
          ),
        );
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion =
        _currentQuestions.isNotEmpty
            ? _currentQuestions[_currentQuestionIndex]
            : null;
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body:
          //hello
          _isAudioLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              )
              : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_gradientStart, _gradientEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    // Custom top bar
                    Container(
                      padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              widget.lesson["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          _isLoading
                              ? const Center(child: LoaderScreen())
                              : _errorMessage != null
                              ? InternetSignalLow(
                                message: _errorMessage!,
                                onRetry: _initAudio,
                              )
                              : _isTransitioning
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                              : !showQuestions
                              ? SingleChildScrollView(
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF957DCD),
                                                Color(0xFF523D7F),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.headphones,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                widget.lesson["title"],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(_position),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(_duration),
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: SliderTheme(
                                          data: SliderTheme.of(
                                            context,
                                          ).copyWith(
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor: Colors.white
                                                .withOpacity(0.3),
                                            thumbColor: Colors.white,
                                            overlayColor: Colors.white
                                                .withOpacity(0.2),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                  enabledThumbRadius: 8,
                                                ),
                                            overlayShape:
                                                const RoundSliderOverlayShape(
                                                  overlayRadius: 16,
                                                ),
                                          ),
                                          child: Slider(
                                            value: _position.inSeconds
                                                .toDouble()
                                                .clamp(
                                                  0.0,
                                                  _duration.inSeconds
                                                      .toDouble(),
                                                ),
                                            min: 0.0,
                                            max:
                                                _duration.inSeconds > 0
                                                    ? _duration.inSeconds
                                                        .toDouble()
                                                    : 1.0,
                                            onChangeStart:
                                                (value) => setState(
                                                  () => _isSeeking = true,
                                                ),
                                            onChangeEnd:
                                                (value) => _seekAudio(value),
                                            onChanged: (value) {
                                              setState(
                                                () =>
                                                    _position = Duration(
                                                      seconds: value.toInt(),
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.replay_10,
                                              size: 32,
                                            ),
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
                                                  colors: [
                                                    Color(0xFF957DCD),
                                                    Color(0xFF523D7F),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                _isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 36,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.forward_10,
                                              size: 32,
                                            ),
                                            color: Colors.white,
                                            onPressed: _skipForward,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF957DCD),
                                                          Color(0xFF523D7F),
                                                        ],
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Now Playing",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.7,
                                                                ),
                                                          ),
                                                    ),
                                                    Text(
                                                      widget.lesson["title"],
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  _isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
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
                                                      child:
                                                          CircularProgressIndicator(
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatDuration(_position),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                                Text(
                                                  _formatDuration(_duration),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SliderTheme(
                                            data: SliderTheme.of(
                                              context,
                                            ).copyWith(
                                              activeTrackColor: Colors.white,
                                              inactiveTrackColor: Colors.white
                                                  .withOpacity(0.3),
                                              thumbColor: Colors.white,
                                              overlayColor: Colors.white
                                                  .withOpacity(0.2),
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                    enabledThumbRadius: 6,
                                                  ),
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                    overlayRadius: 12,
                                                  ),
                                            ),
                                            child: Slider(
                                              value: _position.inSeconds
                                                  .toDouble()
                                                  .clamp(
                                                    0.0,
                                                    _duration.inSeconds
                                                        .toDouble(),
                                                  ),
                                              min: 0.0,
                                              max:
                                                  _duration.inSeconds > 0
                                                      ? _duration.inSeconds
                                                          .toDouble()
                                                      : 1.0,
                                              onChangeStart:
                                                  (value) => setState(
                                                    () => _isSeeking = true,
                                                  ),
                                              onChangeEnd:
                                                  (value) => _seekAudio(value),
                                              onChanged: (value) {
                                                setState(
                                                  () =>
                                                      _position = Duration(
                                                        seconds: value.toInt(),
                                                      ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Question ${_currentQuestionIndex + 1} of ${_currentQuestions.length}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            currentQuestion?["question"] ??
                                                "Loading question...",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ...?currentQuestion?["options"].asMap().entries.map((
                                            entry,
                                          ) {
                                            final int index = entry.key;
                                            final option = entry.value;
                                            final isSelected =
                                                _selectedAnswer == option;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      isSelected
                                                          ? Colors.amber
                                                              .withOpacity(0.8)
                                                          : Colors.white
                                                              .withOpacity(0.1),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    side: BorderSide(
                                                      color:
                                                          isSelected
                                                              ? Colors.amber
                                                              : Colors.white
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                    ),
                                                  ),
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    50,
                                                  ),
                                                ),
                                                onPressed:
                                                    () => _onAnswerSelected(
                                                      option,
                                                    ),
                                                child: Text(
                                                  "${String.fromCharCode(65 + index)}. $option",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        isSelected
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                    color:
                                                        isSelected
                                                            ? Colors.black87
                                                            : Colors.white
                                                                .withOpacity(
                                                                  0.9,
                                                                ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _selectedAnswer != null
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                foregroundColor: Colors.black87,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed:
                                                  _selectedAnswer != null
                                                      ? _nextQuestion
                                                      : null,
                                              child: Text(
                                                _currentQuestionIndex <
                                                        _currentQuestions
                                                                .length -
                                                            1
                                                    ? "Next"
                                                    : "Submit",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}
