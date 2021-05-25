import 'package:kherelcontacts/models/app_contact.dart';
import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';

class AddContactCreateProvider extends BaseProvider {
  AppContact _appContact = AppContact(null, "");

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

      await firestore
          .collection(FSKeys.usersCollection)
          .doc(username)
          .collection(FSKeys.contactsCollection)
          .add(
        {
          "name": "${_appContact.name}",
          "email": "${_appContact.email}",
          "phone": "${_appContact.phone}",
          "photoUrl": "todo",
        },
      );
      _appContact = AppContact(null, "");
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
}
