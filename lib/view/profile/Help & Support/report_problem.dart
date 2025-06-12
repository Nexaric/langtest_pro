import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key, required problemData});

  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  String _selectedIssue = "App Crash"; // Default selected issue

  // List of issue types
  final List<String> _issues = [
    "App Crash",
    "Login Issues",
    "Payment Problems",
    "Course Access Issues",
    "Audio/Video Errors",
    "Other",
  ];

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Submit report function
  void _submitReport() {
    String description = _descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the issue.")),
      );
      return;
    }

    // Handle sending the report (Firebase, API, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted successfully!")),
    );

    // Reset fields after submission
    setState(() {
      _descriptionController.clear();
      _image = null;
      _selectedIssue = "App Crash";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Report a Problem",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  // Select Issue Type
                  Text(
                    "Select Issue Type",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      value: _selectedIssue,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedIssue = newValue!;
                        });
                      },
                      items:
                          _issues.map<DropdownMenuItem<String>>((String issue) {
                            return DropdownMenuItem<String>(
                              value: issue,
                              child: Text(issue),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Issue Description
                  Text(
                    "Describe the Problem",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter details...",
                      hintStyle: GoogleFonts.poppins(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Attach Screenshot
                  Text(
                    "Attach Screenshot (Optional)",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child:
                          _image != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Tap to Upload",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Submit Report",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
