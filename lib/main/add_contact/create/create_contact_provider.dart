import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kherelcontacts/models/app_contact.dart';
import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';
import 'package:kherelcontacts/utils/helpers.dart';

class CreateContactProvider extends BaseProvider {
  AppContact _appContact = AppContact(null, "");
  PickedFile _pickedFile;

  set setContactName(String name) {
    _appContact.name = name;
    errors.remove('name');
    notifyListeners();
  }

  set setPhone(String phone) {
    _appContact.phone = phone;
    errors.remove('phone');
    notifyListeners();
  }

  set setEmail(String email) {
    _appContact.email = email;
    errors.remove('email');
    notifyListeners();
  }

  Future<bool> createContact() async {
    bool success = false;

    if (!validName()) {
      errors['name'] = "At least 4 symbols required";
    }
    if (!validPhone()) {
      errors['phone'] = "Phone required";
    }
    if (!validEmail()) {
      errors['email'] = "Email required";
    }

    if (errors.isEmpty) {
      setLoading = true;

      var photoUrl;
      if (_pickedFile != null) {
        var ref = storage.ref().child('uploads/${getRandomString(32)}.jpg');

        var orgBytes = await _pickedFile.readAsBytes();
        Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
          orgBytes,
          minWidth: 128,
          quality: 60,
        );
        var task = ref.putData(compressedBytes);
        var taskSnapshot = await task.whenComplete(() => null);
        var url = await taskSnapshot.ref.getDownloadURL();
        photoUrl = url;
      }

      var jsonBody = {
        "name": "${_appContact.name ?? ""}",
        "email": "${_appContact.email ?? ""}",
        "phone": "${_appContact.phone ?? ""}",
        "photoUrl": photoUrl ?? "",
      };
      print("creating contact jsonBody: $jsonBody");
      await firestore
          .collection(FSKeys.usersCollection)
          .doc(username)
          .collection(FSKeys.contactsCollection)
          .add(jsonBody);
      _appContact = AppContact(null, "");
      _pickedFile = null;
      success = true;
    }

    setLoading = false;
    return success;
  }

  AppContact get appContact => _appContact;

  set setAppContact(AppContact value) {
    _appContact = value;
    notifyListeners();
  }

  bool validName() {
    return (appContact.name ?? "").length > 3;
  }

  bool validPhone() {
    return (appContact.phone ?? "").isNotEmpty;
  }

  bool validEmail() {
    return (appContact.email ?? "").isNotEmpty;
  }

  PickedFile get pickedFile => _pickedFile;

  set setPickedFile(PickedFile value) {
    _pickedFile = value;
    notifyListeners();
  }
}
