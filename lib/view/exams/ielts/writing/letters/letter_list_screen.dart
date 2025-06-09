import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/formal_letter/formal_letter_7.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_1.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_2.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_3.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_4.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_5.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_6.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/informal_letter/informal_letter_7.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:langtest_pro/controller/writing_progress_provider.dart';

class LetterListScreen extends StatelessWidget {
  const LetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<WritingProgressProvider>(context);
    final theme = Theme.of(context);
    final completedLetterLessons = progressProvider.completedLetterLessons;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "IELTS Writing Task 1: Letters",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Iconsax.medal, color: theme.colorScheme.primary),
            onPressed: () => _showAchievements(context, progressProvider),
            tooltip: 'View Achievements',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Letter Writing Journey",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Chip(
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.2),
                              label: Text(
                                "${(completedLetterLessons / 14 * 100).round()}% Complete",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutQuart,
                              height: 10,
                              width:
                                  MediaQuery.of(context).size.width *
                                  0.9 *
                                  (completedLetterLessons / 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primaryContainer,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      children: [
                        _buildStatCard(
                          context,
                          "Completed",
                          "$completedLetterLessons",
                          Iconsax.tick_circle,
                          theme.colorScheme.primaryContainer,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          context,
                          "Next Letter",
                          completedLetterLessons < 14
                              ? "Letter ${completedLetterLessons + 1}"
                              : "All Done!",
                          Iconsax.arrow_up,
                          theme.colorScheme.tertiaryContainer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(
                  context,
                  "✍️ Letter Writing Lessons",
                  "7 Formal + 7 Informal Letters",
                ),
                ...List.generate(14, (index) {
                  final letterId = index + 1;
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: _buildLetterCard(
                      context,
                      letterId,
                      _getLetterTitle(letterId),
                      _getLetterSubtitle(letterId),
                      letterId <=
                          completedLetterLessons + 1, // Sequential unlocking
                      progressProvider.isLetterLessonCompleted(letterId),
                      _getLetterIcon(letterId),
                      progressProvider,
                    ),
                  );
                }),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterCard(
    BuildContext context,
    int letterId,
    String title,
    String subtitle,
    bool isUnlocked,
    bool isCompleted,
    IconData icon,
    WritingProgressProvider progressProvider,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color:
            isCompleted
                ? theme.colorScheme.primary.withOpacity(0.2)
                : isUnlocked
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap:
              isUnlocked
                  ? () {
                    _openLetter(
                      context,
                      letterId,
                      progressProvider,
                      isCompleted,
                    );
                  }
                  : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                    isCompleted
                        ? theme.colorScheme.primary.withOpacity(0.3)
                        : theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        isCompleted
                            ? theme.colorScheme.primary
                            : isUnlocked
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child:
                      isUnlocked
                          ? Text(
                            "$letterId",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isCompleted
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onPrimaryContainer,
                            ),
                          )
                          : Icon(
                            Iconsax.lock_1,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isUnlocked
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.5,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color:
                              isUnlocked
                                  ? theme.colorScheme.onSurface.withOpacity(0.7)
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.4,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.tick_circle,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Done",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isUnlocked)
                  Icon(
                    Iconsax.arrow_right_3,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  )
                else
                  Tooltip(
                    message: "Complete Letter ${letterId - 1} to unlock",
                    child: Icon(
                      Iconsax.lock_1,
                      size: 20,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLetter(
    BuildContext context,
    int letterId,
    WritingProgressProvider provider,
    bool isCompleted,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _getLetterScreen(letterId)),
    ).then((_) {
      if (provider.isLetterLessonCompleted(letterId) && !isCompleted) {
        _showLetterCompleteDialog(context, letterId);
      }
    });
  }

  void _showLetterCompleteDialog(BuildContext context, int letterId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Letter Completed!",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animations/success.json', height: 100),
                const SizedBox(height: 16),
                Text(
                  "Great job completing Letter $letterId!",
                  style: GoogleFonts.poppins(),
                  textAlign: TextAlign.center,
                ),
                if (letterId < 14)
                  Text(
                    "Letter ${letterId + 1} is now unlocked!",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Continue", style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  void _showAchievements(
    BuildContext context,
    WritingProgressProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Your Letter Achievements",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAchievementItem(
                    context,
                    "Letter Beginner",
                    "Complete Letter 1: Formal Complaint",
                    provider.completedLetterLessons >= 1,
                    Iconsax.edit_2,
                  ),
                  _buildAchievementItem(
                    context,
                    "Formal Letter Expert",
                    "Complete all 7 formal letters",
                    provider.completedLetterLessons >= 7,
                    Iconsax.chart_success,
                  ),
                  _buildAchievementItem(
                    context,
                    "Informal Letter Starter",
                    "Complete Letter 8: Informal Invitation",
                    provider.completedLetterLessons >= 8,
                    Iconsax.star,
                  ),
                  _buildAchievementItem(
                    context,
                    "Letter Master",
                    "Complete all 14 letters",
                    provider.completedLetterLessons >= 14,
                    Iconsax.award,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close", style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  Widget _buildAchievementItem(
    BuildContext context,
    String title,
    String description,
    bool achieved,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            achieved
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color:
              achieved
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      subtitle: Text(
        description,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color:
              achieved
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
      trailing:
          achieved
              ? Icon(
                Iconsax.verify,
                color: Theme.of(context).colorScheme.primary,
              )
              : null,
    );
  }

  String _getLetterTitle(int letterId) {
    const titles = [
      "Formal: Complaint About Product",
      "Formal: Request for Information",
      "Formal: Job Application",
      "Formal: Course Inquiry",
      "Formal: Complaint About Service",
      "Formal: Meeting Request",
      "Formal: Apology for Delay",
      "Informal: Inviting a Friend",
      "Informal: Thanking a Friend",
      "Informal: Apologizing",
      "Informal: Giving Advice",
      "Informal: Sharing News",
      "Informal: Making Plans",
      "Informal: Catch-up Letter",
    ];
    return titles[letterId - 1];
  }

  String _getLetterSubtitle(int letterId) {
    const subtitles = [
      "Write a formal complaint",
      "Request detailed information",
      "Apply for a position",
      "Inquire about a course",
      "Address poor service",
      "Arrange a formal meeting",
      "Apologize formally",
      "Invite a friend to a party",
      "Thank a friend for help",
      "Apologize for missing an event",
      "Advise a friend on moving",
      "Share news about a new job",
      "Suggest a weekend trip",
      "Catch up with a friend",
    ];
    return subtitles[letterId - 1];
  }

  IconData _getLetterIcon(int letterId) {
    const icons = [
      Iconsax.message_minus, // Formal Complaint
      Iconsax.info_circle, // Formal Request
      Iconsax.briefcase, // Formal Application
      Iconsax.book, // Formal Inquiry
      Iconsax.message_remove, // Formal Complaint
      Iconsax.calendar_1, // Formal Request
      Iconsax.message_text, // Formal Apology
      Iconsax.card, // Informal Invitation
      Iconsax.heart, // Informal Thank You
      Iconsax.message_edit, // Informal Apology
      Iconsax.message_question, // Informal Advice
      Iconsax.messages_1, // Informal Sharing News
      Iconsax.map, // Informal Making Plans
      Iconsax.message_2, // Informal Catch-up Letter
    ];
    return icons[letterId - 1];
  }

  Widget _getLetterScreen(int letterId) {
    final lessonData = {'id': letterId, 'title': _getLetterTitle(letterId)};
    switch (letterId) {
      case 1:
        return FormalLetterLesson1(lessonData: lessonData);
      case 2:
        return FormalLetterLesson2(lessonData: lessonData);
      case 3:
        return FormalLetterLesson3(lessonData: lessonData);
      case 4:
        return FormalLetterLesson4(lessonData: lessonData);
      case 5:
        return FormalLetterLesson5(lessonData: lessonData);
      case 6:
        return FormalLetterLesson6(lessonData: lessonData);
      case 7:
        return FormalLetterLesson7(lessonData: lessonData);
      case 8:
        return InformalLetterLesson1(lessonData: lessonData);
      case 9:
        return InformalLetterLesson2(lessonData: lessonData);
      case 10:
        return InformalLetterLesson3(lessonData: lessonData);
      case 11:
        return InformalLetterLesson4(lessonData: lessonData);
      case 12:
        return InformalLetterLesson5(lessonData: lessonData);
      case 13:
        return InformalLetterLesson6(lessonData: lessonData);
      case 14:
        return InformalLetterLesson7(lessonData: lessonData);
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Letter $letterId",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          body: Center(
            child: Text(
              "Letter $letterId: ${_getLetterTitle(letterId)}",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ),
        );
    }
  }
}
