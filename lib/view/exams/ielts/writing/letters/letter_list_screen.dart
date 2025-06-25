import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:langtest_pro/controller/writing/writing_controller.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_data.dart';
import 'package:lottie/lottie.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_screen.dart';

class LetterListScreen extends StatelessWidget {
  const LetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressController = Get.find<WritingProgressController>();

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
            onPressed: () => _showAchievements(context, progressController),
            tooltip: 'View Achievements',
          ),
        ],
      ),
      body: Obx(() {
        final completedLetterLessons =
            progressController.completedLetterLessons;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
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
                                  "${(completedLetterLessons / letterLessons.length * 100).round()}% Complete",
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
                                    (completedLetterLessons /
                                        letterLessons.length),
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
                            completedLetterLessons < letterLessons.length
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
                delegate: SliverChildBuilderDelegate((context, index) {
                  final lesson = letterLessons[index];
                  final letterId = lesson['intId'] as int;
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: _buildLetterCard(
                      context,
                      letterId,
                      lesson['title'] as String,
                      lesson['question'] as String,
                      letterId <= completedLetterLessons + 1,
                      progressController.isLetterLessonCompleted(letterId),
                      lesson['icon'] as IconData,
                      progressController,
                    ),
                  );
                }, childCount: letterLessons.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        );
      }),
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
    WritingProgressController progressController,
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
                      progressController,
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
    WritingProgressController controller,
    bool isCompleted,
  ) {
    final lesson = letterLessons.firstWhere(
      (lesson) => lesson['intId'] == letterId,
      orElse: () => <String, dynamic>{},
    );
    if (lesson.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LetterScreen(lessonData: lesson),
        ),
      ).then((_) {
        if (controller.isLetterLessonCompleted(letterId) && !isCompleted) {
          _showLetterCompleteDialog(context, letterId);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Lesson $letterId not found')),
      );
    }
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
                if (letterId < letterLessons.length)
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
    WritingProgressController controller,
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
              child: Obx(() {
                final completedLetterLessons =
                    controller.completedLetterLessons;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAchievementItem(
                      context,
                      "Letter Beginner",
                      "Complete Letter 1: Complaint About Product",
                      completedLetterLessons >= 1,
                      Iconsax.edit_2,
                    ),
                    _buildAchievementItem(
                      context,
                      "Formal Letter Expert",
                      "Complete all 7 formal letters",
                      completedLetterLessons >= 7,
                      Iconsax.chart_success,
                    ),
                    _buildAchievementItem(
                      context,
                      "Informal Letter Starter",
                      "Complete Letter 8: Inviting a Friend",
                      completedLetterLessons >= 8,
                      Iconsax.star,
                    ),
                    _buildAchievementItem(
                      context,
                      "Letter Master",
                      "Complete all 14 letters",
                      completedLetterLessons >= 14,
                      Iconsax.award,
                    ),
                  ],
                );
              }),
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
}
