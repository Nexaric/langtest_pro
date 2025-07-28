import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  "Dashboard",
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Skill Progress",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildSkillProgress(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillProgress() {
    // Mock data for demonstration
    final mockData = [
      {"title": "Listening", "completed": 12, "total": 20},
      {"title": "Reading", "completed": 8, "total": 15},
      {"title": "Writing", "completed": 5, "total": 10},
      {"title": "Speaking", "completed": 3, "total": 8},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var skill in mockData) ...[
          if (skill != mockData.first) SizedBox(width: 8.w),
          Expanded(
            child: ProgressCard(
              title: skill["title"] as String,
              completed: skill["completed"] as int,
              total: skill["total"] as int,
            ),
          ),
        ],
      ],
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final int completed;
  final int total;

  const ProgressCard({
    super.key,
    required this.title,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (completed / total) : 0;
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 6.h,
            child: LinearProgressIndicator(
              value: 30,
              backgroundColor: Colors.white.withOpacity(0.3),
              color: _getProgressColor(30),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$completed/$total',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.6) return Colors.orange;
    if (percentage < 0.8) return Colors.yellow;
    return Colors.green;
  }
}