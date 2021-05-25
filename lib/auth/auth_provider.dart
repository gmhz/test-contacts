import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';

class AuthProvider extends BaseProvider {
  String _username;

  String get username => _username;

  set setUsername(String value) {
    errors.remove('username');
    _username = value;
    notifyListeners();
  }

  Future<bool> checkAndAuthIfUserExists() async {
    bool success = false;
    if (!validUsername()) {
      errors['username'] = "At least 4 symbols required";
    }

    if (errors.isEmpty) {
      setLoading = true;
      var result =
          await firestore.collection(FSKeys.usersPath).doc(username).get();
      if (result != null && result.exists) {
        errors.clear();
        success = true;
      } else {
        errors['username'] = "User does not exists";
      }
    }

    setLoading = false;
    return success;
  }

  Future<bool> createUserIfNotExists() async {
    bool success = false;
    if (!validUsername()) {
      errors['username'] = "At least 4 symbols required";
    }

    if (errors.isEmpty) {
      setLoading = true;
      var result =
          await firestore.collection(FSKeys.usersPath).doc(username).get();
      if (result != null && result.exists) {
        errors['username'] = "User is already exists";
      } else {
        await firestore.collection(FSKeys.usersPath).doc(username).set({});
        errors.clear();
        success = true;
      }
    }

    setLoading = false;
    return success;
  }

  bool validUsername() => _username.isNotEmpty && _username.length > 3;
}
