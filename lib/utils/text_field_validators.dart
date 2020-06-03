class TextFieldValidators{
  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return 'Please enter a valid email';
    else
      return null;
  }

  static String nameValidator(String value) {
    if (value.trim().isEmpty)
      return '*Required';
    else
      return null;
  }

  static String passwordValidator(String value) {
    if (value.isEmpty) {
      return '*Required';
    }
    if (value.contains(" ")) {
      return 'Please do not use a space in passoword';
    }
    if (value.length < 6) {
      return 'Please choose a password with more than 6 characters';
    } else {
      return null;
    }
  }
}