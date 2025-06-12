import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key, required preferencesData});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool notificationsEnabled = true;

  void _savePreferences() {
    print("Notifications Enabled: $notificationsEnabled");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Preferences saved successfully!",
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
          "Preferences",
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                color: Colors.white.withOpacity(0.95),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  title: Text(
                    "Enable Notifications",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  subtitle: Text(
                    "Receive app notifications for updates and reminders",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  activeColor: const Color(0xFF3E1E68),
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _savePreferences,
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
                    "Save Preferences",
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
}
