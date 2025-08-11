import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:langtest_pro/controller/profile/profile_controller.dart';
import 'package:langtest_pro/model/userData_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserData usrModel;

  const EditProfileScreen({super.key, required this.usrModel});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final profileController = Get.put(ProfileController());
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  String? _dob;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(
      text: widget.usrModel.firstName,
    );
    _phoneController = TextEditingController(text: widget.usrModel.phone);
    _lastnameController = TextEditingController(text: widget.usrModel.lastName);
    _emailController = TextEditingController(text: widget.usrModel.email);
    _selectedGender = widget.usrModel.gender;
    _dob = widget.usrModel.dob;
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // void _printUserData() {
  //   final updatedUserData = {
  //     'name': _nameController.text,
  //     'email': _emailController.text,
  //     'gender': _selectedGender,
  //     'dob': _dob,
  //   };

  //   print('Updated User Data:');
  //   updatedUserData.forEach((key, value) {
  //     print('$key: $value');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF6A5AE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "First Name",
                            Icons.person_outline,
                            _firstnameController,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Last Name",
                            Icons.person_outline,
                            _lastnameController,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Phone Number",
                            Icons.person_outline,
                            _phoneController,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Email",
                            Icons.email_outlined,
                            _emailController,
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDropdown(
                            "Gender",
                            Icons.transgender,
                            ["Male", "Female", "Other", "Prefer not to say"],
                            _selectedGender,
                            (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDatePicker(
                            "Date of Birth",
                            Icons.calendar_today_outlined,
                            _dob!,
                            () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() {
                                  _dob =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 30.h),
                        BounceInUp(
                          duration: const Duration(milliseconds: 800),
                          child: SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () =>
                                  profileController.isLoading.value
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.deepPurple,
                                        ),
                                      )
                                      : ElevatedButton(
                                        onPressed: () {
                                          final phone =
                                              _phoneController.text.trim();
                                          final isValidPhone = RegExp(
                                            r'^[0-9]{10}$',
                                          ).hasMatch(phone);
      
                                          if (_firstnameController
                                                  .text
                                                  .isEmpty ||
                                              _lastnameController
                                                  .text
                                                  .isEmpty ||
                                              _selectedGender == null ||
                                              _dob == null ||
                                              phone.isEmpty ||
                                              !isValidPhone) {
                                            String errorMsg =
                                                'Please fill all fields';
                                            if (!isValidPhone) {
                                              errorMsg =
                                                  'Phone number must be 10 digits and numeric only';
                                            }
      
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  errorMsg,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }
      
                                          final usrDataModel = UserData(
                                            phone: phone,
                                            uid: widget.usrModel.uid,
                                            firstName:
                                                _firstnameController.text,
                                            lastName: _lastnameController.text,
                                            dob: _dob!,
                                            gender: _selectedGender!,
                                            email: _emailController.text,
                                            role: widget.usrModel.role,
                                            isCompleted:
                                                widget.usrModel.isCompleted,
                                            // Add phone if your UserData has it:
                                            // phone: phone,
                                          );
      
                                          profileController.updateProfile(
                                            userDataModel: usrDataModel,
                                          );
                                        },
      
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16.h,
                                            horizontal: 40.w,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          elevation: 5,
                                          shadowColor: Colors.black.withOpacity(
                                            0.2,
                                          ),
                                        ),
                                        child: Text(
                                          "Save Changes",
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF6A5AE0),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).viewInsets.bottom > 0
                                  ? MediaQuery.of(context).viewInsets.bottom +
                                      20.h
                                  : 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

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
        fontSize: 15.sp,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
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
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    IconData icon,
    String date,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8)),
            SizedBox(width: 12.w),
            Text(
              date.isNotEmpty ? date : label,
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color:
                    date.isNotEmpty
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
