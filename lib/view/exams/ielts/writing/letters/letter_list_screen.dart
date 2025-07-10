import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:langtest_pro/controller/writing_controller.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_data.dart';
import 'package:langtest_pro/view/exams/ielts/writing/letters/letter_screen.dart';

class LetterListScreen extends StatelessWidget {
  const LetterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressController = Get.find<WritingController>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'IELTS Writing Task 1: Letters',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.medal,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            onPressed: () => _showAchievements(context, progressController),
            tooltip: 'View Achievements',
          ),
        ],
      ),
      body: Obx(() {
        final completedLetters =
            progressController
                .completedLetters; // Fixed: completedLetterLessons -> completedLetters
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                                'Your Letter Writing Journey',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Chip(
                                backgroundColor: theme.colorScheme.primary
                                    .withOpacity(0.1),
                                label: Text(
                                  '${(completedLetters / letterLessons.length * 100).round()}% Complete',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutQuart,
                                height: 6,
                                width:
                                    MediaQuery.of(context).size.width *
                                    0.9 *
                                    (completedLetters / letterLessons.length),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primaryContainer,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Row(
                        children: [
                          _buildStatCard(
                            context,
                            'Completed',
                            '$completedLetters',
                            Iconsax.tick_circle,
                            theme.colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            context,
                            'Next Letter',
                            completedLetters < letterLessons.length
                                ? 'Letter ${completedLetters + 1}'
                                : 'All Done!',
                            Iconsax.arrow_up,
                            theme.colorScheme.secondaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      letterId <= completedLetters + 1,
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
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
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

  Widget _buildLetterCard(
    BuildContext context,
    int letterId,
    String title,
    String subtitle,
    bool isUnlocked,
    bool isCompleted,
    IconData icon,
    WritingController progressController,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color:
            isCompleted
                ? theme.colorScheme.primary.withOpacity(0.1)
                : isUnlocked
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap:
              isUnlocked
                  ? () => _openLetter(
                    context,
                    letterId,
                    progressController,
                    isCompleted,
                  )
                  : null,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isCompleted
                        ? theme.colorScheme.primary.withOpacity(0.2)
                        : theme.colorScheme.outline.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
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
                            '$letterId',
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              isUnlocked
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.5,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color:
                              isUnlocked
                                  ? theme.colorScheme.onSurface.withOpacity(0.7)
                                  : theme.colorScheme.onSurface.withOpacity(
                                    0.4,
                                  ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
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
                          'Done',
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
                    size: 18,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  )
                else
                  Tooltip(
                    message: 'Complete Letter ${letterId - 1} to unlock',
                    child: Icon(
                      Iconsax.lock_1,
                      size: 18,
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
    WritingController controller,
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
        SnackBar(
          content: Text('Error: Letter $letterId not found'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showLetterCompleteDialog(BuildContext context, int letterId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Letter Completed!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/animations/success.json',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 12),
                Text(
                  'Great job completing Letter $letterId!',
                  style: GoogleFonts.poppins(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                if (letterId < letterLessons.length)
                  Text(
                    'Letter ${letterId + 1} is now unlocked!',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showAchievements(BuildContext context, WritingController controller) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              'Your Letter Achievements',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            content: SingleChildScrollView(
              child: Obx(() {
                final completedLetters =
                    controller
                        .completedLetters; // Fixed: completedLetterLessons -> completedLetters
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAchievementItem(
                      context,
                      'Letter Beginner',
                      'Complete Letter 1: Complaint About Product',
                      completedLetters >= 1,
                      Iconsax.edit_2,
                    ),
                    _buildAchievementItem(
                      context,
                      'Formal Letter Expert',
                      'Complete all 7 formal letters',
                      completedLetters >= 7,
                      Iconsax.chart_success,
                    ),
                    _buildAchievementItem(
                      context,
                      'Informal Letter Starter',
                      'Complete Letter 8: Inviting a Friend',
                      completedLetters >= 8,
                      Iconsax.star,
                    ),
                    _buildAchievementItem(
                      context,
                      'Letter Master',
                      'Complete all 14 letters',
                      completedLetters >= 14,
                      Iconsax.award,
                    ),
                  ],
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
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
        size: 20,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 14,
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
                size: 20,
              )
              : null,
    );
  }
}
