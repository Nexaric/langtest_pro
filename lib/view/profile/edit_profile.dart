import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:animate_do/animate_do.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required userData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController(
    text: "John Doe",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "johndoe@example.com",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+91 9876543210",
  );
  String _selectedGender = "Male";
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6A5AE0),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6A5AE0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A5AE0), Color(0xFF9B78FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // Profile Picture with edit icon
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  backgroundImage:
                                      _image != null
                                          ? FileImage(_image!)
                                          : null,
                                  child:
                                      _image == null
                                          ? const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color(0xFF6A5AE0),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Input Fields
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Full Name",
                            Icons.person_outline,
                            _nameController,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Email",
                            Icons.email_outlined,
                            _emailController,
                            enabled: false,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Phone",
                            Icons.phone_outlined,
                            _phoneController,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Gender Dropdown
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDropdown(
                            "Gender",
                            Icons.transgender,
                            ["Male", "Female", "Other", "Prefer not to say"],
                            _selectedGender,
                            (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date of Birth Picker
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDatePicker(
                            "Date of Birth",
                            Icons.calendar_today_outlined,
                            _selectedDate,
                            () {
                              _selectDate(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Save Button
                        BounceInUp(
                          duration: const Duration(milliseconds: 800),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Save action
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Profile updated successfully!',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: const Color(0xFF6A5AE0),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 40,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child: Text(
                                "Save Changes",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF6A5AE0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Add extra space at the bottom to ensure gradient covers when keyboard opens
                        SizedBox(
                          height:
                              MediaQuery.of(context).viewInsets.bottom > 0
                                  ? MediaQuery.of(context).viewInsets.bottom +
                                      20
                                  : 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Custom Input Field
  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  // Custom Dropdown Field
  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items,
    String selectedItem,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        dropdownColor: const Color(0xFFF5F5FF),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Custom Date Picker
  Widget _buildDatePicker(
    String label,
    IconData icon,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8)),
            const SizedBox(width: 12),
            Text(
              date != null
                  ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
                  : label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color:
                    date != null ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
