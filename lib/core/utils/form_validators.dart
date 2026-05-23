class FormValidators {
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else {
      final firstChar = value!.trim()[0];
      if (firstChar != firstChar.toUpperCase()) {
        return 'First letter must be uppercase';
      }
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') && !value.contains('.com')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phone = value.trim();

    if (phone.length != 11) {
      return 'Phone number must be 11 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must contain only numbers';
    }

    return null;
  }

  static String? confirmPasswordValidator({
    required String? password,
    required String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? emailOrPhoneValidator(String? value) {
    if (value != null && value.contains('@')) {
      return FormValidators.email(value);
    } else if (value != null && !!RegExp(r'^\d+$').hasMatch(value)) {
      return FormValidators.phoneValidator(value);
    } else {
      return 'Please enter a valid email or phone number';
    }
  }
}