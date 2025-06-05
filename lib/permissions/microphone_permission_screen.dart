/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:langtest_pro/profile/user_info_screen.dart';

class MicrophonePermissionScreen extends StatelessWidget {
  const MicrophonePermissionScreen({super.key});

  Future<void> requestMicrophonePermission(BuildContext context) async {
    var statusMic = await Permission.microphone.request();
    var statusPhone = await Permission.phone.request();

    if (statusMic.isGranted && statusPhone.isGranted) {
      // Navigate to User Info Screen after granting permission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserInfoScreen()),
      );
    } else {
      // Handle denied permission (optional)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, size: 100, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Text(
                  "Enable Microphone & Phone Access",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Allow microphone access for voice interaction and AI conversation, and phone access for better experience.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => requestMicrophonePermission(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Allow Access",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF6A5AE0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Skip permission and go to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserInfoScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Skip for now",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */
