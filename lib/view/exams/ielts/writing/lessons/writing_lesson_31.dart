import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'lesson_result.dart';
import 'lesson_list_screen.dart';

class WritingLesson31 extends StatefulWidget {
  const WritingLesson31({super.key, required lessonData});

  @override
  State<WritingLesson31> createState() => _WritingLesson31State();
}

class _WritingLesson31State extends State<WritingLesson31>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _essayController = TextEditingController();
  late final AnimationController _saveAnimationController;
  late final Animation<double> _saveScaleAnimation;
  int _wordCount = 0;
  bool _showSample = false;
  bool _showTips = false;
  bool _isSubmitting = false;
  bool _isLoading = true;
  bool _showSaveIndicator = false;
  late String _storagePath;
  late File _essayFile;

  final Map<String, dynamic> _task = {
    'title': 'Opinion Essay – Democracy vs. Authoritarianism',
    'icon': Icons.gavel,
    'question':
        'Some argue authoritarian governments achieve faster economic growth. Is democracy still the best system?',
    'sampleAnswer': '''
Sample Answer (360 words)

The debate over democracy versus authoritarianism often hinges on economic efficiency, with some lauding the latter’s swift decision-making. However, I contend that democracy, despite its complexities, remains the superior system due to its resilience, inclusivity, and long-term stability.

Authoritarian regimes, such as China, are often praised for rapid development. From 1980 to 2020, China’s GDP grew at 9.5% annually, per World Bank data, driven by centralized policies. Such regimes bypass bureaucratic gridlock, enabling swift infrastructure projects—China’s high-speed rail network, spanning 40,000 km by 2024, exemplifies this. Proponents argue that democracy’s deliberative processes, prone to partisan deadlock, as seen in the U.S. Congress’s 2023 budget disputes, hinder progress. Authoritarianism also suppresses dissent, ensuring policy continuity, unlike democracies where populist shifts can disrupt long-term plans.

Yet, democracy’s strengths outweigh these advantages. First, it fosters innovation through freedom of expression. The U.S., a democratic leader, hosts 70% of the world’s top tech firms, per a 2024 Forbes report, thriving on open discourse absent in authoritarian states, where censorship stifles creativity—China’s internet firewall blocks 10,000 sites daily, per Freedom House. Second, democracy ensures accountability, reducing corruption’s economic toll, estimated at 5% of global GDP by the IMF in 2023. Authoritarian states like Russia, ranked 137th on Transparency International’s 2024 Corruption Index, suffer from unchecked kleptocracy. Third, democracies promote equitable growth; Scandinavian nations, with high democratic indices, boast Gini coefficients below 0.30, unlike authoritarian Qatar’s 0.41, per 2023 World Bank data.

Counterarguments highlight democracy’s inefficiencies, such as India’s slow infrastructure growth, averaging 4% annually versus China’s 8%, per a 2024 ADB report. However, authoritarianism’s short-term gains often mask fragility—Sudan’s 2023 collapse under autocratic rule underscores this. Democracies, by contrast, adapt through elections, as seen in South Korea’s 1987 democratic transition, which sustained 5% annual growth.

In conclusion, while authoritarianism offers expediency, democracy’s innovation, accountability, and equity ensure sustainable progress. Strengthening democratic institutions, not abandoning them, is the path forward.
''',
    'tips': '''
Expert Tips

1. Structure:
   - Introduction: Acknowledge authoritarian efficiency, state pro-democracy stance
   - Paragraph 1: Authoritarian strengths (speed, continuity)
   - Paragraph 2: Democracy’s advantages (innovation, accountability)
   - Paragraph 3: Counterarguments and rebuttal (efficiency vs. fragility)
   - Conclusion: Reaffirm democracy’s superiority

2. Linking Words:
   - Strengths: "for instance", "notably", "additionally"
   - Counterarguments: "however", "conversely", "nevertheless"

3. Vocabulary:
   - Authoritarian: "centralized governance", "policy continuity", "suppressed dissent"
   - Democracy: "deliberative processes", "equitable growth", "institutional resilience"

4. Examples:
   - China’s 9.5% GDP growth
   - U.S.’s 70% tech firm dominance
   - Russia’s corruption ranking
''',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      _essayFile = File('$_storagePath/essay_response_31.json');
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
    _essayController.addListener(() {
      _updateWordCount();
    });
  }

  bool _isValidInput(String input) {
    return RegExp(r'^[A-Za-z0-9 ]*$').hasMatch(input);
  }

  Future<void> _saveResponse() async {
    try {
      final response = _essayController.text;
      if (!_isValidInput(response)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Only letters (A-Z, a-z), numbers, and spaces are allowed.',
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
      await _essayFile.writeAsString(jsonEncode(data));
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
                lessonNumber: 31,
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
          Text(
            _task['title'],
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
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
                        Icon(_task['icon'], color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Question',
                          style: TextStyle(
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
          ),
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
                  controller: _essayController,
                  maxLines: 12,
                  minLines: 6,
                  style: const TextStyle(height: 1.5),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (!_isValidInput(newValue.text)) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Only letters (A-Z, a-z), numbers, and spaces are allowed.',
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
                    hintText: 'Start typing your response here...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
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
                            'Characters: ${_essayController.text.length}\n'
                            'Last saved: ${_getLastModifiedTime()}',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _wordCount >= 150
                                    ? Colors.green[50]
                                    : Colors.orange[50],
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _wordCount >= 150
                                          ? Colors.green[700]
                                          : Colors.orange[700],
                                ),
                              ),
                              Text(
                                '/150',
                                style: TextStyle(
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
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Saved',
                                style: TextStyle(
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
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
          ),
          const SizedBox(height: 24),
          if (_showTips)
            _buildExpandableSection(
              icon: Icons.lightbulb_outline,
              iconColor: Colors.orange[700]!,
              title: 'Expert Writing Tips',
              content: _task['tips'],
            ),
          if (_showSample)
            _buildExpandableSection(
              icon: Icons.auto_awesome,
              iconColor: Colors.purple[700]!,
              title: 'Sample Answer (Band 9)',
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
          Text(label, style: TextStyle(color: color)),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'IELTS Writing Lesson 31',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: Colors.red[600],
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
