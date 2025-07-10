import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/lesson_result.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/lesson_list_screen.dart';
import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_data.dart';

class WritingScreen extends StatefulWidget {
  final int lessonNumber;
  const WritingScreen({super.key, required this.lessonNumber});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _essayController = TextEditingController();
  late AnimationController _saveAnimationController;
  late Animation<double> _saveScaleAnimation;
  int _wordCount = 0;
  bool _showSample = false;
  bool _showTips = false;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _showSaveIndicator = false;
  late String _storagePath;
  late File _essayFile;
  late Map<String, dynamic> _task;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _task = WritingData.lessons[widget.lessonNumber - 1];
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveScaleAnimation = CurvedAnimation(
      parent: _saveAnimationController,
      curve: Curves.elasticOut,
    );
    _initStorage().then((_) {
      _loadSavedResponse().then((_) {
        setState(() => _isLoading = false);
      });
    });
    _setupController();
  }

  Future<void> _initStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _storagePath = directory.path;
      _essayFile = File(
        '$_storagePath/essay_response_${widget.lessonNumber}.json',
      );
    } catch (e) {
      debugPrint('Error initializing storage: $e');
    }
  }

  Future<void> _loadSavedResponse() async {
    try {
      if (await _essayFile.exists()) {
        final content = await _essayFile.readAsString();
        final data = jsonDecode(content);
        final response = data['response'] ?? '';
        if (_isValidInput(response)) {
          _essayController.text = response;
          _updateWordCount();
        } else {
          _essayController.text = '';
          _updateWordCount();
        }
      }
    } catch (e) {
      debugPrint('Error loading saved response: $e');
    }
  }

  void _setupController() {
    _essayController.addListener(_updateWordCount);
  }

  bool _isValidInput(String input) {
    return RegExp(r'^[A-Za-z0-9 ]*$').hasMatch(input);
  }

  Future<void> _saveResponse() async {
    try {
      final response = _essayController.text;
      if (!_isValidInput(response)) {
        _showSnackBar('Only letters, numbers, and spaces are allowed.');
        return;
      }
      final data = {
        'response': response,
        'lastSaved': DateTime.now().toIso8601String(),
        'wordCount': _wordCount,
      };
      await _essayFile.writeAsString(jsonEncode(data));
      setState(() {
        _showSaveIndicator = true;
      });
      _saveAnimationController.reset();
      _saveAnimationController.forward();
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _showSaveIndicator = false;
      });
    } catch (e) {
      debugPrint('Error saving response: $e');
      _showSnackBar('Failed to save response: $e');
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
    final wordCount = _countWords(_essayController.text);
    setState(() {
      _wordCount = wordCount;
    });
  }

  Future<void> _submitResponse() async {
    setState(() => _isSubmitting = true);

    try {
      await _saveResponse();

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder:
              (_, __, ___) => LessonResult(
                academicWordCount: _wordCount,
                generalWordCount: 0,
                onFinish:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LessonListScreen(),
                      ),
                    ),
                lessonNumber: widget.lessonNumber,
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
      _showSnackBar('Failed to submit response: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteResponse() async {
    try {
      setState(() {
        _essayController.clear();
        _wordCount = 0;
      });
      await _essayFile.writeAsString(
        jsonEncode({
          'response': '',
          'lastSaved': DateTime.now().toIso8601String(),
          'wordCount': 0,
        }),
      );
      _showSnackBar('Response deleted');
    } catch (e) {
      _showSnackBar('Failed to delete response: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
          Text(
            _task['title'],
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildQuestionCard(),
          const SizedBox(height: 24),
          _buildWritingArea(),
          const SizedBox(height: 24),
          _buildActionButtons(),
          const SizedBox(height: 24),
          if (_showTips) _buildTipsSection(),
          if (_showSample) _buildSampleSection(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => HapticFeedback.lightImpact(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_task['icon'], color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Question',
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
    );
  }

  Widget _buildWritingArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              TextField(
                controller: _essayController,
                maxLines: 10,
                minLines: 6,
                style: GoogleFonts.poppins(height: 1.5),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (!_isValidInput(newValue.text)) {
                      _showSnackBar(
                        'Only letters, numbers, or spaces are allowed',
                      );
                      return oldValue;
                    }
                    return newValue;
                  }),
                ],
                decoration: InputDecoration(
                  hintText: 'Start typing your response here...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              _buildWordCountContainer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWordCountContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Tooltip(
            message:
                'Word count: $_wordCount\nCharacters: ${_essayController.text.length}\nLast saved: ${_getLastModifiedTime()}',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _wordCount >= 150 ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _wordCount >= 150
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
                        _wordCount >= 150
                            ? Colors.green[700]
                            : Colors.orange[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_wordCount',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color:
                          _wordCount >= 150
                              ? Colors.green[700]
                              : Colors.orange[700],
                    ),
                  ),
                  Text(
                    '/150',
                    style: GoogleFonts.poppins(
                      color:
                          _wordCount >= 150
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
                  Icon(Icons.check_circle, size: 14, color: Colors.green[500]),
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
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionButton(
          icon: Icons.lightbulb,
          label: _showTips ? 'Hide Tips' : 'Show Tips',
          color: Colors.orange,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() => _showTips = !_showTips);
          },
        ),
        _buildActionButton(
          icon: Icons.visibility_outlined,
          label: _showSample ? 'Hide Sample' : 'Show Sample Answer',
          color: Colors.purple,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() => _showSample = !_showSample);
          },
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitResponse,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child:
              _isSubmitting
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.send, size: 16),
                      SizedBox(width: 6),
                      Text('Submit'),
                    ],
                  ),
        ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        side: BorderSide(color: color.withOpacity(0.2)),
        backgroundColor: color.withOpacity(0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(color: color)),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return _buildExpandableSection(
      icon: Icons.lightbulb,
      iconColor: Colors.orange[600]!,
      title: 'Expert Writing Tips',
      content: _task['tips'],
    );
  }

  Widget _buildSampleSection() {
    return _buildExpandableSection(
      icon: Icons.auto_awesome,
      iconColor: Colors.purple[600]!,
      title: 'Sample Answer (Band 9)',
      content: _task['sampleAnswer'],
    );
  }

  String _getLastModifiedTime() {
    try {
      if (!_essayFile.existsSync()) {
        return 'Not saved yet';
      }
      final stat = _essayFile.statSync();
      final modified = stat.modified;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (modified.isAfter(today)) {
        return 'Today at ${modified.hour}:${modified.minute.toString().padLeft(2, '0')}';
      }
      return '${modified.day}/${modified.month}/${modified.year}';
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
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 12,
            bottom: 10,
          ),
          leading: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                content,
                style: GoogleFonts.poppins(fontSize: 12, height: 1.5),
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
          'IELTS Writing Lesson ${widget.lessonNumber}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outlined, color: Colors.red[600]),
            tooltip: 'Delete essay',
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
    _essayController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
