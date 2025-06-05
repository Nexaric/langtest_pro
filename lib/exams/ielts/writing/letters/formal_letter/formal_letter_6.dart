import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:langtest_pro/exams/ielts/writing/writing_progress_provider.dart';
import 'package:langtest_pro/exams/ielts/writing/writing_result.dart';

class FormalLetterLesson6 extends StatefulWidget {
  final Map<String, dynamic> lessonData;

  const FormalLetterLesson6({super.key, required this.lessonData});

  @override
  State<FormalLetterLesson6> createState() => _FormalLetterLesson6State();
}

class _FormalLetterLesson6State extends State<FormalLetterLesson6>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Controllers
  final TextEditingController _letterController = TextEditingController();

  // Animation Controllers
  late final AnimationController _saveAnimationController;
  late final Animation<double> _saveScaleAnimation;

  // State variables
  int _wordCount = 0;
  bool _showSample = false;
  bool _showTips = false;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _showSaveIndicator = false;

  // Storage
  late String _storagePath;
  late File _letterFile;

  // Task content
  final Map<String, dynamic> _task = {
    'title': 'Requesting Information',
    'icon': Icons.edit,
    'question':
        'You are interested in attending a training course offered by a company. Write a letter to the company requesting more information about the course details, including dates, costs, and content.',
    'sampleAnswer': '''
📝 Sample Answer

Dear Sir/Madam,

I am writing to inquire about the details of the Project Management Training Course advertised on your website. I am keen to enhance my professional skills and believe this course would be highly beneficial.

Could you please provide further information regarding the course schedule, including start and end dates? Additionally, I would appreciate details on the total cost, including any available discounts, and an overview of the course content.

Please send the information to my email address or contact me at 01234 567890. I look forward to your response.

Yours faithfully,
James Carter

(105 words)
''',
    'tips': '''
💡 Expert Tips

1. Structure:
   - Sender Address: Your address at the top
   - Date: Below your address
   - Receiver Address: Company name or department
   - Salutation: Use "Dear Sir/Madam" or specific contact
   - Body: State purpose, request details, provide contact info
   - Closing: Use "Yours faithfully" or "Yours sincerely"

2. Tone:
   - Be polite and professional
   - Avoid vague or demanding language

3. Content:
   - Clearly state the course or topic of interest
   - Specify the information needed (e.g., dates, costs)
   - Include your contact details for follow-up

4. Length:
   - Aim for 100-150 words
   - Be concise but clear
''',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize animation controllers
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveScaleAnimation = CurvedAnimation(
      parent: _saveAnimationController,
      curve: Curves.elasticOut,
    );

    // Initialize storage and load data
    _initStorage().then((_) {
      _loadSavedResponse().then((_) {
        setState(() => _isLoading = false);
      });
    });

    // Setup text controller
    _setupController();
  }

  Future<void> _initStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _storagePath = directory.path;
      _letterFile = File('$_storagePath/formal_letter_6.json');
    } catch (e) {
      debugPrint('Error initializing storage: $e');
    }
  }

  Future<void> _loadSavedResponse() async {
    try {
      if (await _letterFile.exists()) {
        final content = await _letterFile.readAsString();
        final data = jsonDecode(content);
        final response = data['response'] ?? '';
        if (_isValidInput(response)) {
          _letterController.text = response;
          _updateWordCount();
        } else {
          _letterController.text = '';
          _updateWordCount();
        }
      }
    } catch (e) {
      debugPrint('Error loading saved response: $e');
    }
  }

  void _setupController() {
    _letterController.addListener(() {
      _updateWordCount();
    });
  }

  bool _isValidInput(String input) {
    return RegExp(r'^[A-Za-z0-9 ,.\n\r!?]*$').hasMatch(input);
  }

  Future<void> _saveResponse() async {
    try {
      final response = _letterController.text;
      if (!_isValidInput(response)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Only letters, numbers, spaces, punctuation, and newlines are allowed.',
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        return;
      }

      final data = {
        'response': response,
        'lastSaved': DateTime.now().toIso8601String(),
        'wordCount': _wordCount,
      };
      await _letterFile.writeAsString(jsonEncode(data));

      // Show save indicator animation
      setState(() => _showSaveIndicator = true);
      _saveAnimationController.reset();
      _saveAnimationController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _showSaveIndicator = false);
    } catch (e) {
      debugPrint('Error saving response: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save response: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveResponse();
    }
  }

  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 1 || word.contains(RegExp(r'\w')))
        .length;
  }

  void _updateWordCount() {
    final wordCount = _countWords(_letterController.text);
    setState(() {
      _wordCount = wordCount;
    });
  }

  Future<void> _submitResponse() async {
    setState(() => _isSubmitting = true);

    try {
      await _saveResponse();

      final score = _calculateScore(_letterController.text);
      Provider.of<WritingProgressProvider>(
        context,
        listen: false,
      ).completeLetterLesson(widget.lessonData['id']);

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder:
              (_, __, ___) => WritingResultScreen(
                score: score,
                feedback: _generateFeedback(score),
                taskType: widget.lessonData['title'],
                lessonData: widget.lessonData,
              ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutQuart,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit response: $e'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  double _calculateScore(String text) {
    final wordCount = text.split(' ').length;
    final sentenceCount = text.split('.').length - 1;
    final wordScore = (wordCount / 100).clamp(0.0, 1.0) * 3;
    final sentenceScore = (sentenceCount / 4).clamp(0.0, 1.0) * 2;
    return 4.0 + wordScore + sentenceScore + (Random().nextDouble() * 1.5);
  }

  String _generateFeedback(double score) {
    if (score >= 8.0) {
      return "Excellent inquiry letter! Your request is clear, polite, and well-structured.";
    } else if (score >= 6.0) {
      return "Good effort. Specify more details or maintain a formal tone.";
    } else {
      return "Needs improvement. Focus on clarity and providing specific requests.";
    }
  }

  Future<void> _deleteResponse() async {
    try {
      setState(() {
        _letterController.clear();
        _wordCount = 0;
      });

      await _letterFile.writeAsString(
        jsonEncode({
          'response': '',
          'lastSaved': DateTime.now().toIso8601String(),
          'wordCount': 0,
        }),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Response deleted'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete response: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildTaskView() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Loading your saved work...',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title at the top
          Text(
            _task['title'],
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),

          // Question Card
          Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Task',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _task['question'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Writing Area
          Text(
            'YOUR RESPONSE',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 0.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _letterController,
                  maxLines: 12,
                  minLines: 6,
                  style: GoogleFonts.poppins(height: 1.5),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9 ,.\n\r!?]*'),
                    ),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (!_isValidInput(newValue.text)) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Only letters, numbers, spaces, punctuation, and newlines are allowed.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                        return oldValue;
                      }
                      return newValue;
                    }),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Start typing your letter here...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      Tooltip(
                        message:
                            'Word count: $_wordCount\n'
                            'Characters: ${_letterController.text.length}\n'
                            'Last saved: ${_getLastModifiedTime()}',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _wordCount >= 100
                                    ? Colors.green[50]
                                    : Colors.orange[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  _wordCount >= 100
                                      ? Colors.green[100]!
                                      : Colors.orange[100]!,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.text_fields,
                                size: 14,
                                color:
                                    _wordCount >= 100
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$_wordCount',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _wordCount >= 100
                                          ? Colors.green[700]
                                          : Colors.orange[700],
                                ),
                              ),
                              Text(
                                '/100',
                                style: GoogleFonts.poppins(
                                  color:
                                      _wordCount >= 100
                                          ? Colors.green[700]
                                          : Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_showSaveIndicator)
                        ScaleTransition(
                          scale: _saveScaleAnimation,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Saved',
                                style: GoogleFonts.poppins(
                                  color: Colors.green[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Tips Button
              _buildActionButton(
                icon: Icons.lightbulb_outline,
                label: _showTips ? 'Hide Tips' : 'Show Tips',
                color: Colors.orange,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _showTips = !_showTips;
                  });
                },
              ),

              // Sample Answer Button
              _buildActionButton(
                icon: Icons.visibility_outlined,
                label: _showSample ? 'Hide Sample' : 'Show Sample Answer',
                color: Colors.purple,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _showSample = !_showSample;
                  });
                },
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitResponse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send, size: 18),
                            const SizedBox(width: 6),
                            Text('Submit', style: GoogleFonts.poppins()),
                          ],
                        ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tips Section
          if (_showTips)
            _buildExpandableSection(
              icon: Icons.lightbulb_outline,
              iconColor: Colors.orange[700]!,
              title: 'Expert Writing Tips',
              content: _task['tips'],
            ),

          // Sample Answer Section
          if (_showSample)
            _buildExpandableSection(
              icon: Icons.auto_awesome,
              iconColor: Colors.purple[700]!,
              title: 'Sample Answer',
              content: _task['sampleAnswer'],
            ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: color.withOpacity(0.3)),
        backgroundColor: color.withOpacity(0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(color: color)),
        ],
      ),
    );
  }

  String _getLastModifiedTime() {
    try {
      if (!_letterFile.existsSync()) return 'Not saved yet';

      final stat = _letterFile.statSync();
      final modified = stat.modified;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (modified.isAfter(today)) {
        return 'Today at ${modified.hour}:${modified.minute.toString().padLeft(2, '0')}';
      } else {
        return '${modified.day}/${modified.month}/${modified.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content,
                style: GoogleFonts.poppins(fontSize: 15, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'IELTS Writing: Formal Letter 6',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[600]),
            tooltip: 'Delete letter',
            onPressed: _deleteResponse,
          ),
        ],
      ),
      body: _buildTaskView(),
    );
  }

  @override
  void dispose() {
    _saveAnimationController.dispose();
    _letterController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
