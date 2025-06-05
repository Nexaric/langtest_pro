import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _generalNotifications = true;
  bool _courseUpdates = true;
  bool _examReminders = false;
  bool _aiAssistantAlerts = true;

  void _saveSettings() {
    // Placeholder for saving settings (e.g., to Firebase)
    print(
      "Saved notification settings: "
      "General: $_generalNotifications, "
      "Course Updates: $_courseUpdates, "
      "Exam Reminders: $_examReminders, "
      "AI Assistant: $_aiAssistantAlerts",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Settings saved successfully!",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF3E1E68),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notification Settings",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color.fromARGB(255, 84, 65, 228)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage Notifications",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                "📢 General Notifications",
                "Receive app-wide updates and announcements",
                _generalNotifications,
                (value) => setState(() => _generalNotifications = value),
              ),
              _buildSwitchTile(
                "📚 Course Updates",
                "Get notified about new course content",
                _courseUpdates,
                (value) => setState(() => _courseUpdates = value),
              ),
              _buildSwitchTile(
                "⏰ Exam Reminders",
                "Reminders for upcoming tests and deadlines",
                _examReminders,
                (value) => setState(() => _examReminders = value),
              ),
              _buildSwitchTile(
                "🤖 AI Assistant Alerts",
                "Alerts from your AI tutor and practice sessions",
                _aiAssistantAlerts,
                (value) => setState(() => _aiAssistantAlerts = value),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  child: Text(
                    "Save Settings",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3E1E68),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white.withOpacity(0.95),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(
          Icons.notifications,
          color: value ? const Color(0xFF3E1E68) : Colors.grey,
          size: 32,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF718096),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF3E1E68),
          inactiveTrackColor: Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
