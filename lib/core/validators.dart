class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }
}
