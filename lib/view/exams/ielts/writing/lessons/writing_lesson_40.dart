import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'lesson_result.dart';
import 'lesson_list_screen.dart';

class WritingLesson40 extends StatefulWidget {
  const WritingLesson40({super.key, required lessonData});

  @override
  State<WritingLesson40> createState() => _WritingLesson40State();
}

class _WritingLesson40State extends State<WritingLesson40>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Controllers and animations
  final TextEditingController _essayController = TextEditingController();
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
  late File _essayFile;

  // Lesson content
  static const _lessonNumber = 40;
  static const _minWordCount = 150;
  final Map<String, dynamic> _task = {
    'title': 'Opinion Essay – Space Exploration',
    'question':
        'Is space exploration a worthwhile investment, or should funds be redirected to earthly priorities?',
    'sampleAnswer': '''
Sample Answer (370 words)

Space exploration, a hallmark of human ambition, sparks debate over its value versus its cost. I firmly believe it is a worthwhile investment, driving scientific advancement and global cooperation, despite arguments prioritizing terrestrial needs.

Space exploration yields unparalleled benefits. Scientifically, it expands knowledge; NASA's Mars rovers uncovered evidence of ancient water, per a 2024 study, advancing astrobiology. Technologically, spin-offs like GPS and medical imaging, derived from space research, contribute 400 billion annually to the global economy, per a 2023 OECD report. Economically, the space industry employs 1.2 million globally, per a 2024 Space Foundation study, fostering innovation. Moreover, international collaboration, as seen in the International Space Station, unites 15 nations, reducing geopolitical tensions, per a 2023 UN report. These outcomes justify continued investment.

Critics argue that space exploration diverts funds from pressing issues like poverty and healthcare. In 2023, global space spending reached 120 billion, per Euroconsult, while 9% of the world's population lives below the poverty line, per World Bank data. Developing nations, like India, face scrutiny for space programs when 20% lack basic sanitation, per a 2024 WHO report. Yet, this view overlooks long-term gains. Space technologies, like satellite-based weather forecasting, saved 2 billion in disaster losses in 2023, per NOAA, benefiting vulnerable regions. Additionally, space inspires STEM education; 60% of U.S. science graduates cite space missions as motivation, per a 2024 NSF study, building human capital to address earthly challenges.

Counterarguments suggest reallocating funds could solve immediate crises, but history shows dual progress is possible. The U.S. Apollo program cost 150 billion (adjusted), yet the 1960s saw poverty rates drop 10%, per Census data, proving ambitious projects can coexist with social progress. Neglecting space risks stagnation; China's 2024 lunar base plans signal a competitive future. Balanced budgets, like the EU's 20 billion Horizon program, show investment in science and welfare need not be mutually exclusive.

In conclusion, space exploration's scientific, economic, and diplomatic benefits outweigh its costs, provided strategic budgeting ensures terrestrial needs are met. Continued investment, paired with equitable policies, secures humanity's future both on Earth and beyond.
''',
    'tips': '''
Expert Tips

1. Structure:
   - Introduction: State opinion favoring space exploration, acknowledge counterarguments
   - Paragraph 1: Benefits (scientific, technological, economic, diplomatic)
   - Paragraph 2: Counterarguments (cost, earthly priorities)
   - Paragraph 3: Rebuttal and evidence (dual progress, long-term gains)
   - Conclusion: Reaffirm opinion, emphasize balanced approach

2. Linking Words:
   - Benefits: "for instance", "moreover", "additionally"
   - Counterarguments: "however", "conversely", "critics argue"
   - Rebuttal: "nevertheless", "yet", "ultimately"

3. Vocabulary:
   - Benefits: "unparalleled advancements", "technological spin-offs", "global cooperation"
   - Counterarguments: "diverted funds", "pressing terrestrial needs", "economic scrutiny"

4. Examples:
   - 400B from space tech
   - 1.2M space industry jobs
   - 9% global poverty rate
''',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _initializeStorage();
    _setupTextController();
  }

  void _initializeAnimations() {
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _saveScaleAnimation = CurvedAnimation(
      parent: _saveAnimationController,
      curve: Curves.elasticOut,
    );
  }

  Future<void> _initializeStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _storagePath = directory.path;
      _essayFile = File('$_storagePath/essay_response_$_lessonNumber.json');
      await _loadSavedResponse();
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Storage initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Failed to initialize storage', isError: true),
        );
      }
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
        }
      }
    } catch (e) {
      debugPrint('Error loading saved response: $e');
    }
  }

  void _setupTextController() {
    _essayController.addListener(_updateWordCount);
  }

  bool _isValidInput(String input) {
    return RegExp(r'^[A-Za-z0-9').hasMatch(input);
  }

  Future<void> _saveResponse() async {
    try {
      final response = _essayController.text;
      if (!_isValidInput(response)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            _buildSnackBar(
              'Only letters, numbers, and basic punctuation are allowed',
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

      await _essayFile.writeAsString(jsonEncode(data));
      if (!mounted) return;

      setState(() => _showSaveIndicator = true);
      _saveAnimationController.reset();
      _saveAnimationController.forward();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _showSaveIndicator = false);
    } catch (e) {
      debugPrint('Error saving response: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Failed to save response', isError: true),
        );
      }
    }
  }

  SnackBar _buildSnackBar(String message, {bool isError = false}) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isError ? Colors.red[600] : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
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
    if (mounted) setState(() => _wordCount = wordCount);
  }

  Future<void> _submitResponse() async {
    if (_wordCount < _minWordCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(
          'Please write at least $_minWordCount words before submitting',
        ),
      );
      return;
    }

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
                lessonNumber: _lessonNumber,
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
      debugPrint('Submission error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('Failed to submit response', isError: true),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_buildSnackBar('Response cleared'));
    } catch (e) {
      debugPrint('Deletion error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_buildSnackBar('Failed to clear response', isError: true));
    }
  }

  Widget _buildLoadingIndicator() {
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
              Text(
                _task['question'],
                style: const TextStyle(
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

  Widget _buildResponseField() {
    return Container(
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
            controller: _essayController,
            maxLines: 12,
            minLines: 6,
            style: const TextStyle(height: 1.5),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (!_isValidInput(newValue.text)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar('Invalid characters entered'),
                    );
                  }
                  return oldValue;
                }
                return newValue;
              }),
            ],
            decoration: InputDecoration(
              hintText: 'Start typing your response here...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
          _buildWordCountBar(),
        ],
      ),
    );
  }

  Widget _buildWordCountBar() {
    final isWordCountSufficient = _wordCount >= _minWordCount;
    final colorScheme = isWordCountSufficient ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                'Characters: ${_essayController.text.length}\n'
                'Last saved: ${_getLastModifiedTime()}',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme[100]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_fields, size: 14, color: colorScheme[700]),
                  const SizedBox(width: 6),
                  Text(
                    '$_wordCount/$_minWordCount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme[700],
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
                  Icon(Icons.check_circle, size: 16, color: Colors.green[500]),
                  const SizedBox(width: 6),
                  Text(
                    'Saved',
                    style: TextStyle(color: Colors.green[500], fontSize: 12),
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
          icon: Icons.lightbulb_outline,
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
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
                  : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.send, size: 18),
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
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
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
            style: TextStyle(
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
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLastModifiedTime() {
    try {
      if (!_essayFile.existsSync()) return 'Not saved yet';
      final stat = _essayFile.statSync();
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

  Widget _buildTaskView() {
    if (_isLoading) return _buildLoadingIndicator();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _task['title'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildQuestionCard(),
          const SizedBox(height: 24),
          Text(
            'YOUR RESPONSE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              letterSpacing: 0.5,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          _buildResponseField(),
          const SizedBox(height: 24),
          _buildActionButtons(),
          if (_showTips) ...[
            const SizedBox(height: 24),
            _buildExpandableSection(
              icon: Icons.lightbulb_outline,
              iconColor: Colors.orange[700]!,
              title: 'Expert Writing Tips',
              content: _task['tips'],
            ),
          ],
          if (_showSample) ...[
            const SizedBox(height: 24),
            _buildExpandableSection(
              icon: Icons.auto_awesome,
              iconColor: Colors.purple[700]!,
              title: 'Sample Answer (Band 9)',
              content: _task['sampleAnswer'],
            ),
          ],
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'IELTS Writing Lesson $_lessonNumber',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[600],
            tooltip: 'Clear essay',
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
