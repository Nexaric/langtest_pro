// lib/view/exams/ielts/listening/audio_lessons/audio_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/listening/audio_lessons/audio_lessons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:langtest_pro/core/loading/internet_signel_low.dart';
import 'package:langtest_pro/core/loading/loader_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'audio_result.dart';
import 'questions/question_manager.dart';

class AudioScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final VoidCallback onComplete;

  const AudioScreen({
    required this.lesson,
    required this.onComplete,
    super.key,
  });

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  bool _isAudioLoading = true;
  String audioPath = '';
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

  final Color _gradientStart = const Color(0xFF3E1E68);
  final Color _gradientEnd = const Color.fromARGB(255, 84, 65, 228);

  @override
  void initState() {
    super.initState();
    _loadAudio();
   
  }

  void _loadQuestions() {
    if (widget.lesson["isIntroduction"] == true) {
      return; // Skip questions for lesson 1
    }
    final lessonId = widget.lesson["lessonId"] as int;
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
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isTransitioning = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            final lessonId = widget.lesson["lessonId"] as int;
            if (widget.lesson["isIntroduction"] == true) {
              // Mark lesson 1 as completed
              // _progressController.updateLessonProgress(
              //   lessonId.toString(),
              //   'lesson_completed',
              // );
              widget.onComplete();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AudioLessonsScreen(),
                ),
                (Route<dynamic> route) => route.isFirst,
              );
            } else {
              // Show questions for lessons 2-50
              setState(() {
                showQuestions = true;
                _isPlaying = false;
                _isTransitioning = false;
                // _progressController.updateLessonProgress(
                //   lessonId.toString(),
                //   'question_opened',
                // );
              });
            }
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
        final lessonId = widget.lesson["lessonId"] as int;

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
                  onComplete: widget.onComplete,
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      body:
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
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        16.w,
                        MediaQuery.of(context).padding.top + 16.h,
                        16.w,
                        16.h,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              widget.lesson["isIntroduction"] == true
                                  ? "Introduction: ${widget.lesson["title"].toString().split(":").length > 1 ? widget.lesson["title"].toString().split(":")[1].trim() : widget.lesson["title"]}"
                                  : widget.lesson["title"],
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                              "_progressController.getProgress",
                              // '${(_progressController.getProgress((widget.lesson["lessonId"] as int).toString()) * 100).toStringAsFixed(0)}%',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.white,
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
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 4.w,
                                ),
                              )
                              : !showQuestions
                              ? SingleChildScrollView(
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
                                            borderRadius: BorderRadius.circular(
                                              20.r,
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
                                                blurRadius: 20.r,
                                                offset: Offset(0, 10.h),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.headphones,
                                                size: 80.sp,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 20.h),
                                              Text(
                                                widget.lesson["isIntroduction"] ==
                                                        true
                                                    ? "Introduction"
                                                    : widget.lesson["title"],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
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
                                            thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 8.r,
                                            ),
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                  overlayRadius: 16.r,
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
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.replay_10,
                                              size: 32.sp,
                                            ),
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
                                                    blurRadius: 10.r,
                                                    offset: Offset(0, 5.h),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                _isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 36.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            icon: Icon(
                                              Icons.forward_10,
                                              size: 32.sp,
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
                                      margin: EdgeInsets.all(16.w),
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        8.r,
                                                      ),
                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF957DCD),
                                                          Color(0xFF523D7F),
                                                        ],
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Now Playing",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 12.sp,
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
                                                            fontSize: 14.sp,
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
                                                  size: 20.sp,
                                                ),
                                                onPressed: _playPause,
                                              ),
                                              _isReloading
                                                  ? Padding(
                                                    padding: EdgeInsets.all(
                                                      8.w,
                                                    ),
                                                    child: SizedBox(
                                                      width: 20.w,
                                                      height: 20.h,
                                                      child:
                                                          CircularProgressIndicator(
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _formatDuration(_position),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                                Text(
                                                  _formatDuration(_duration),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
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
                                              thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 6.r,
                                              ),
                                              overlayShape:
                                                  RoundSliderOverlayShape(
                                                    overlayRadius: 12.r,
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
                                    SizedBox(height: 20.h),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
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
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            currentQuestion?["question"] ??
                                                "Loading question...",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.sp,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              height: 1.5,
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          ...?currentQuestion?["options"].asMap().entries.map((
                                            entry,
                                          ) {
                                            final int index = entry.key;
                                            final option = entry.value;
                                            final isSelected =
                                                _selectedAnswer == option;
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
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
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12.h,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
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
                                                  minimumSize: Size(
                                                    double.infinity,
                                                    50.h,
                                                  ),
                                                ),
                                                onPressed:
                                                    () => _onAnswerSelected(
                                                      option,
                                                    ),
                                                child: Text(
                                                  "${String.fromCharCode(65 + index)}. $option",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.sp,
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
                                          SizedBox(height: 20.h),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    _selectedAnswer != null
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                foregroundColor: Colors.black87,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24.w,
                                                  vertical: 12.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
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
                                                  fontSize: 14.sp,
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
