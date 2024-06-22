class Validation {
  String? validateEmail(String? email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email == null || email.isEmpty) {
      return 'Email address is required';
    } else if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  String? validateUsername(String? username) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_]{3,16}$');
    if (username == null || username.isEmpty) {
      return 'Username is required';
    } else if (!regex.hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores';
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    if (password == null || password.isEmpty) {
      return 'Password is required';
    } else if (!regex.hasMatch(password)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    } else if (confirmPassword != password) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  String? validateCategory(String? category) {
    if (category == null || category.isEmpty) {
      return 'category is required';
    }
      return null;
    }
  String? validateNote(String? note) {
    if (note == null || note.isEmpty) {
      return 'note is required';
    }
    return null;
  }
}
