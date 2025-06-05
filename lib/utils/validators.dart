class Validators {
  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  // Validate Password (8+ characters, 1 special character, 1 number)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'(?=.*?[#?!@$%^&*-])').hasMatch(value)) {
      return "Password must include a special character";
    }
    if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
      return "Password must include a number";
    }
    return null;
  }

  // Validate Name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters long";
    }
    return null;
  }
}
