import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BaseProvider with ChangeNotifier {
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
}
