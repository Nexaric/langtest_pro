import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:animate_do/animate_do.dart';

class EditProfileController extends GetxController {
  var imagePath = Rx<File?>(null);
  var name = 'John Doe'.obs;
  var email = 'johndoe@example.com'.obs;
  var phone = '+91 9876543210'.obs;
  var selectedGender = 'Male'.obs;
  var selectedDate = Rx<DateTime?>(null);

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = File(pickedFile.path);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2000, 1, 1),
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
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  void saveProfile() {
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      backgroundColor: const Color(0xFF6A5AE0),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      margin: EdgeInsets.all(16.w),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

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
          onPressed: () => Get.back(),
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
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2.w,
                                  ),
                                ),
                                child: Obx(
                                  () => CircleAvatar(
                                    radius: 50.r,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.2,
                                    ),
                                    backgroundImage:
                                        controller.imagePath.value != null
                                            ? FileImage(
                                              controller.imagePath.value!,
                                            )
                                            : null,
                                    child:
                                        controller.imagePath.value == null
                                            ? Icon(
                                              Icons.person,
                                              size: 50.sp,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: controller.pickImage,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10.w,
                                          offset: Offset(0, 4.h),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: const Color(0xFF6A5AE0),
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Full Name",
                            Icons.person_outline,
                            controller.name,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Email",
                            Icons.email_outlined,
                            controller.email,
                            enabled: false,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildTextField(
                            "Phone",
                            Icons.phone_outlined,
                            controller.phone,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDropdown("Gender", Icons.transgender, [
                            "Male",
                            "Female",
                            "Other",
                            "Prefer not to say",
                          ], controller.selectedGender),
                        ),
                        SizedBox(height: 16.h),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: _buildDatePicker(
                            "Date of Birth",
                            Icons.calendar_today_outlined,
                            controller.selectedDate,
                            () => controller.selectDate(context),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        BounceInUp(
                          duration: const Duration(milliseconds: 800),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 40.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.2),
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
    RxString controller, {
    bool enabled = true,
  }) {
    return Obx(
      () => TextField(
        controller: TextEditingController(text: controller.value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: controller.value.length),
          ),
        onChanged: (value) => controller.value = value,
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
          contentPadding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    IconData icon,
    List<String> items,
    RxString selectedItem,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
      ),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: selectedItem.value,
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
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (value) => selectedItem.value = value!,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    IconData icon,
    Rx<DateTime?> date,
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
            Obx(
              () => Text(
                date.value != null
                    ? "${date.value!.day.toString().padLeft(2, '0')}/${date.value!.month.toString().padLeft(2, '0')}/${date.value!.year}"
                    : label,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color:
                      date.value != null
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
