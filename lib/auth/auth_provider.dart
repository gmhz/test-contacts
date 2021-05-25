import 'dart:async';

import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';

class AuthProvider extends BaseProvider {
  StreamController<String> userStream = StreamController<String>.broadcast();

  Future<bool> checkAndAuthIfUserExists() async {
    bool success = false;
    if (!validUsername()) {
      errors['username'] = "At least 4 symbols required";
    }

    if (errors.isEmpty) {
      setLoading = true;
      var result = await firestore
          .collection(FSKeys.usersCollection)
          .doc(username)
          .get();
      if (result != null && result.exists) {
        errors.clear();
        success = true;
        userStream.add(username);
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
      var result = await firestore
          .collection(FSKeys.usersCollection)
          .doc(username)
          .get();
      if (result != null && result.exists) {
        errors['username'] = "User is already exists";
      } else {
        await firestore
            .collection(FSKeys.usersCollection)
            .doc(username)
            .set({});
        errors.clear();
        success = true;
        userStream.add(username);
      }
    }

    setLoading = false;
    return success;
  }


}
