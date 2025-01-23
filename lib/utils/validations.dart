class Validation {
  final RegExp validMobileNumberCharacters = RegExp(r'^[0-9]+$');
  static RegExp validEmail = RegExp(
      r'^[a-zA-Z0-9.!#$%&‘+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)$');
  final validUrl = RegExp(
      r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

  String? validateEmail(String email) {
    if (email.isNotEmpty) {
      if (!validEmail.hasMatch(email)) {
        return 'Please enter valid email';
      }
    } else {
      return 'Email cannot be empty';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }

    if (password.length < 8) {
      return 'Password must be greater than 8 characters';
    }

    bool containsUpperCase = false;
    for (int i = 0; i < password.length; i++) {
      if (password[i] == password[i].toUpperCase() && password[i] != password[i].toLowerCase()) {
        containsUpperCase = true;
        break;
      }
    }
    if (!containsUpperCase) {
      return 'Password must have one upper case';
    }

    bool containsLowerCase = false;
    for (int i = 0; i < password.length; i++) {
      if (password[i] == password[i].toLowerCase() && password[i] != password[i].toUpperCase()) {
        containsLowerCase = true;
        break;
      }
    }
    if (!containsLowerCase) {
      return 'Password must have one upper case';
    }

    bool containsNumber = false;
    for (int i = 0; i < password.length; i++) {
      if (password.codeUnitAt(i) >= 48 && password.codeUnitAt(i) <= 57) {
        containsNumber = true;
        break;
      }
    }
    if (!containsNumber) {
      return 'Password must have one number';
    }

    const specialCharacters = r'@$!%*?&[]{}()#_';

    bool containsSpecialCharacter = false;
    for (int i = 0; i < password.length; i++) {
      if (specialCharacters.contains(password[i])) {
        containsSpecialCharacter = true;
        break;
      }
    }
    if (!containsSpecialCharacter) {
      return 'Password must have one special character';
    }

    return null;
  }
}
