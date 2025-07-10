import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Added import
import 'package:path_provider/path_provider.dart';
import 'package:langtest_pro/controller/writing_controller.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_data.dart';
import 'package:langtest_pro/view/exams/ielts/writing/writing_result.dart';

class LetterScreen extends StatefulWidget {
  final Map<String, dynamic> lessonData;

  const LetterScreen({super.key, required this.lessonData});

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _letterController = TextEditingController();
  final WritingController _progressController = Get.find<WritingController>();
  late AnimationController _saveAnimationController;
  late Animation<double> _saveScaleAnimation;
  int _wordCount = 0;
  bool _showSample = false;
  bool _showTips = false;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _showSaveIndicator = false;
  late String _storagePath;
  late File _letterFile;
  late Map<String, dynamic> _task;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _task = widget.lessonData;
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
      _letterFile = File('$_storagePath/letter_${_task['intId']}.json');
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
    _letterController.addListener(_updateWordCount);
  }

  bool _isValidInput(String input) {
    return RegExp(r'^[A-Za-z0-9 ,.\n\r!?]*$').hasMatch(input);
  }

  Future<void> _saveResponse() async {
    try {
      final response = _letterController.text;
      if (!_isValidInput(response)) {
        _showSnackBar(
          'Only letters, numbers, spaces, punctuation, and newlines are allowed.',
        );
        return;
      }
      final data = {
        'response': response,
        'lastSaved': DateTime.now().toIso8601String(),
        'wordCount': _wordCount,
      };
      await _letterFile.writeAsString(jsonEncode(data));
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
      _showSnackBar('Error saving response: $e');
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
      await _progressController.completeLetterLesson(_task['intId']);
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
                taskType: _task['title'],
                wordCount: _wordCount,
                lessonData: _task,
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

  double _calculateScore(String text) {
    final wordCount = _countWords(text);
    final sentenceCount =
        text.split('.').where((s) => s.trim().isNotEmpty).length;
    final targetWords = _task['type'] == 'Formal' ? 100 : 80;
    final wordScore = (wordCount / targetWords).clamp(0.0, 1.0) * 3;
    final sentenceScore = (sentenceCount / 4).clamp(0.0, 1.0) * 2;
    return (4.0 + wordScore + sentenceScore).clamp(0.0, 9.0);
  }

  String _generateFeedback(double score) {
    if (_task['type'] == 'Formal') {
      if (score >= 8.0) {
        return 'Excellent formal letter! Your tone is professional, and the content is clear and well-structured.';
      } else if (score >= 6.0) {
        return 'Good effort. Ensure a formal tone and include specific details for clarity.';
      } else {
        return 'Needs improvement. Focus on formal language and detailed explanations.';
      }
    } else {
      if (score >= 8.0) {
        return 'Excellent informal letter! Your tone is warm, engaging, and includes relevant details.';
      } else if (score >= 6.0) {
        return 'Good effort. Add a more personal touch or include more specific details.';
      } else {
        return 'Needs improvement. Use a friendlier tone and provide clear details.';
      }
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
      _showSnackBar('Response deleted');
    } catch (e) {
      _showSnackBar('Failed to delete response: $e');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 12)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            SizedBox(height: 16),
            Text(
              'Loading your saved work...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _task['title'],
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 12),
          _buildQuestionCard(),
          const SizedBox(height: 16),
          _buildWritingArea(),
          const SizedBox(height: 16),
          _buildActionButtons(),
          const SizedBox(height: 16),
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
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => HapticFeedback.lightImpact(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Iconsax.task, size: 20, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Task',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _task['question'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
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
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontSize: 12,
            letterSpacing: 0.5,
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
                controller: _letterController,
                maxLines: 10,
                minLines: 6,
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Za-z0-9 ,.\n\r!?]*'),
                  ),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (!_isValidInput(newValue.text)) {
                      _showSnackBar(
                        'Only letters, numbers, spaces, punctuation, and newlines are allowed.',
                      );
                      return oldValue;
                    }
                    return newValue;
                  }),
                ],
                decoration: InputDecoration(
                  hintText: 'Start typing your letter here...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
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
    final targetWords = _task['type'] == 'Formal' ? 100 : 80;
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
                'Word count: $_wordCount\nCharacters: ${_letterController.text.length}\nLast saved: ${_getLastModifiedTime()}',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    _wordCount >= targetWords
                        ? Colors.green[50]
                        : Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _wordCount >= targetWords
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
                        _wordCount >= targetWords
                            ? Colors.green[700]
                            : Colors.orange[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_wordCount',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color:
                          _wordCount >= targetWords
                              ? Colors.green[700]
                              : Colors.orange[700],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '/$targetWords',
                    style: GoogleFonts.poppins(
                      color:
                          _wordCount >= targetWords
                              ? Colors.green[700]
                              : Colors.orange[700],
                      fontSize: 12,
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
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.send, size: 16),
                      const SizedBox(width: 6),
                      Text('Submit', style: GoogleFonts.poppins(fontSize: 14)),
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
          Text(label, style: GoogleFonts.poppins(color: color, fontSize: 12)),
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
      title: 'Sample Answer',
      content: _task['sampleAnswer'],
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
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 12,
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
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontSize: 14,
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
          'IELTS Writing: ${_task['type']} Letter ${_task['intId'] - (_task['type'] == 'Formal' ? 0 : 7)}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outlined, color: Colors.red[600], size: 22),
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
