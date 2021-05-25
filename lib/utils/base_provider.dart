import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BaseProvider with ChangeNotifier {
  String base_username = 'ermek';

  String get username => base_username;

  set setUsername(String value) {
    errors.remove('username');
    base_username = value;
    notifyListeners();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _loading = false;
  Map<String, String> errors = Map<String, String>();

  bool get isLoading => _loading;

  set setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String getError(String key) {
    return errors[key];
  }

  Map<String, String> getErrors() {
    return errors;
  }

  void clearErrors() {
    errors.clear();
    notifyListeners();
  }

  bool validUsername() => username.isNotEmpty && username.length > 3;
}
