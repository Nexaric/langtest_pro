import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/writing/writing_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:langtest_pro/view/exams/ielts/writing/lessons/writing_screen.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "IELTS Writing Task 2 Mastery",
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
            onPressed: () => _showAchievements(context),
            tooltip: 'View Achievements',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Obx(() {
                final progressController =
                    Get.find<WritingProgressController>();
                final completedLessons = progressController.completedLessons;

                return Column(
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
                                "Your Writing Journey",
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
                                  "${progressController.completionPercentage}% Complete",
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
                                    progressController.progress,
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
                            "$completedLessons",
                            Iconsax.tick_circle,
                            theme.colorScheme.primaryContainer,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            context,
                            "Next Lesson",
                            completedLessons < 40
                                ? "Lesson ${completedLessons + 1}"
                                : "All Done!",
                            Iconsax.arrow_up,
                            theme.colorScheme.tertiaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(
                  context,
                  "✍️ Writing Task 2 Lessons",
                  "40 Lessons to Master Essay Writing",
                ),
                ...List.generate(40, (index) {
                  final lessonNumber = index + 1;
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    child: Obx(() {
                      final progressController =
                          Get.find<WritingProgressController>();
                      final isCompleted = progressController.isLessonCompleted(
                        lessonNumber,
                      );
                      final isUnlocked =
                          lessonNumber <=
                          progressController.completedLessons + 1;

                      return _buildLessonCard(
                        context,
                        lessonNumber,
                        _getTask2Title(lessonNumber),
                        _getTask2Subtitle(lessonNumber),
                        isUnlocked,
                        isCompleted,
                        _getTask2Icon(lessonNumber),
                        progressController,
                      );
                    }),
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

  Widget _buildLessonCard(
    BuildContext context,
    int lessonNumber,
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
                    _openLesson(
                      context,
                      lessonNumber,
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
                            "$lessonNumber",
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
                    message: "Complete Lesson ${lessonNumber - 1} to unlock",
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

  void _openLesson(
    BuildContext context,
    int lessonNumber,
    WritingProgressController controller,
    bool isCompleted,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _getLessonScreen(lessonNumber)),
    ).then((_) {
      if (controller.isLessonCompleted(lessonNumber) && !isCompleted) {
        _showLessonCompleteDialog(context, lessonNumber);
      }
    });
  }

  void _showLessonCompleteDialog(BuildContext context, int lessonNumber) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Lesson Completed!",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/animations/success.json', height: 100),
                const SizedBox(height: 16),
                Text(
                  "Great job completing Lesson $lessonNumber!",
                  style: GoogleFonts.poppins(),
                  textAlign: TextAlign.center,
                ),
                if (lessonNumber < 40)
                  Text(
                    "Lesson ${lessonNumber + 1} is now unlocked!",
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

  void _showAchievements(BuildContext context) {
    final progressController = Get.find<WritingProgressController>();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Your Achievements",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Obx(() {
                final completedLessons = progressController.completedLessons;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAchievementItem(
                      context,
                      "Essay Beginner",
                      "Complete Lesson 1: Technology",
                      completedLessons >= 1,
                      Iconsax.edit_2,
                    ),
                    _buildAchievementItem(
                      context,
                      "Starter",
                      "Complete your first lesson",
                      completedLessons > 0,
                      Iconsax.star,
                    ),
                    _buildAchievementItem(
                      context,
                      "Essay Master",
                      "Complete Lessons 1-10",
                      completedLessons >= 10,
                      Iconsax.chart_success,
                    ),
                    _buildAchievementItem(
                      context,
                      "Advanced Writer",
                      "Complete Lessons 11-20",
                      completedLessons >= 20,
                      Iconsax.edit,
                    ),
                    _buildAchievementItem(
                      context,
                      "Writing Pro",
                      "Complete all 40 lessons",
                      completedLessons >= 40,
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

  String _getTask2Title(int lesson) {
    const titles = [
      "Technology: Convenience or Complication?",
      "Education: Practical vs. Creative Subjects",
      "Advantages of Remote Work",
      "Solving Urban Traffic Congestion",
      "Protecting Endangered Species",
      "Social Media: Benefits vs. Drawbacks",
      "Free Healthcare for All",
      "Impacts of Fast Food",
      "Addressing Youth Unemployment",
      "Challenges of Aging Populations",
      "Space Exploration vs. Earth Problems",
      "Universal Basic Income: Solution or Problem?",
      "Pros and Cons of Online Education",
      "Reducing Plastic Pollution",
      "AI: Benefits and Risks",
      "Censorship vs. Free Speech",
      "Globalization: Positive or Negative?",
      "Tourism: Economic vs. Cultural Impact",
      "Combating the Obesity Epidemic",
      "Accelerating Renewable Energy",
      "Ethics of Genetic Engineering",
      "Minimum Wage: Benefits vs. Costs",
      "Gig Economy: Flexibility vs. Security",
      "Protecting Against Cybercrime",
      "Managing Overpopulation",
      "Animal Testing: Ethics vs. Necessity",
      "Preserving Cultural Heritage",
      "E-books vs. Paper Books",
      "Addressing the Mental Health Crisis",
      "Urban Planning for Growth",
      "Global Tourism: Cultural Impact",
      "Urbanization: Challenges and Solutions",
      "Automation: Economic Impacts",
      "Income Inequality: Causes and Solutions",
      "Climate Change: Global Responsibility",
      "Capital Punishment: Ethics and Justice",
      "Homeschooling vs. Traditional Schools",
      "Artificial Intelligence: Benefits vs. Risks",
      "Urban Overcrowding: Causes and Solutions",
      "Space Exploration: Worthwhile Investment?",
    ];
    return titles[lesson - 1];
  }

  String _getTask2Subtitle(int lesson) {
    const subtitles = [
      "Discuss convenience vs. complications",
      "Practical subjects vs. arts",
      "Remote work pros and cons",
      "Causes and solutions for traffic",
      "Human impact on wildlife",
      "Social media's impact",
      "Free vs. paid healthcare",
      "Health and economic effects",
      "Youth joblessness solutions",
      "Aging population challenges",
      "Space vs. terrestrial spending",
      "UBI: Poverty vs. work ethic",
      "Online vs. traditional learning",
      "Causes and solutions for plastic",
      "AI's transformative potential",
      "Censorship vs. misinformation",
      "Global trade's effects",
      "Tourism's dual impact",
      "Causes and solutions for obesity",
      "Transition to renewables",
      "Genetic engineering ethics",
      "Minimum wage trade-offs",
      "Gig economy's impact",
      "Cybersecurity vulnerabilities",
      "Overpopulation challenges",
      "Animal testing ethics",
      "Cultural preservation efforts",
      "Digital vs. physical books",
      "Mental health support",
      "Urban overcrowding solutions",
      "Tourism's cultural effects",
      "Urbanization's challenges",
      "Automation's economic effects",
      "Addressing wealth disparities",
      "Global climate action",
      "Death penalty ethics",
      "Homeschooling's social impact",
      "AI's societal implications",
      "Mitigating urban overcrowding",
      "Space exploration vs. earthly priorities",
    ];
    return subtitles[lesson - 1];
  }

  IconData _getTask2Icon(int lesson) {
    final icons = [
      Iconsax.device_message,
      Iconsax.book_1,
      Iconsax.briefcase,
      Iconsax.car,
      Iconsax.tree,
      Iconsax.messages_1,
      Iconsax.hospital,
      Iconsax.cake,
      Iconsax.user,
      Iconsax.people,
      Iconsax.airplane,
      Iconsax.money_4,
      Iconsax.monitor,
      Iconsax.trash,
      Iconsax.cpu,
      Iconsax.security,
      Iconsax.global,
      Iconsax.building_3,
      Iconsax.weight,
      Iconsax.flash,
      Iconsax.code,
      Iconsax.wallet,
      Iconsax.task,
      Iconsax.shield_tick,
      Iconsax.profile_2user,
      Iconsax.bezier,
      Iconsax.building,
      Iconsax.book,
      Iconsax.heart,
      Iconsax.location,
      Iconsax.map,
      Iconsax.building_4,
      Iconsax.chart,
      Iconsax.money_send,
      Iconsax.cloud_snow,
      Iconsax.judge,
      Iconsax.teacher,
      Iconsax.command,
      Iconsax.radar,
      Iconsax.airplane_square,
    ];
    return icons[lesson - 1];
  }

  Widget _getLessonScreen(int lessonNumber) {
    if (lessonNumber >= 1 && lessonNumber <= 40) {
      return WritingScreen(lessonNumber: lessonNumber);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lesson $lessonNumber",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text(
          "Lesson $lessonNumber: ${_getTask2Title(lessonNumber)}",
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
