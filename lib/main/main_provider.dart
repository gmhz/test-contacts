import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kherelcontacts/models/app_contact.dart';
import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';

class MainProvider extends BaseProvider {
  List<AppContact> contacts = List.empty(growable: true);

  Future<bool> createContact() async {
    bool success = false;

    if (errors.isEmpty) {
      setLoading = true;
      var result =
          await firestore.collection(FSKeys.usersCollection).doc().get();
      if (result != null && result.exists) {
        errors['username'] = "User is already exists";
      } else {
        await firestore
            .collection(FSKeys.usersCollection)
            .doc(username)
            .set({});
        errors.clear();
        success = true;
      }
    }

    setLoading = false;
    return success;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> myContactsLive() {
    return firestore
        .collection(FSKeys.usersCollection)
        .doc(username)
        .collection(FSKeys.contactsCollection)
        .snapshots();
  }
}
