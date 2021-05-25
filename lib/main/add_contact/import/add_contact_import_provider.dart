import 'package:collection/collection.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kherelcontacts/models/app_contact.dart';
import 'package:kherelcontacts/utils/base_provider.dart';
import 'package:kherelcontacts/utils/firestore.dart';

class AddContactImportProvider extends BaseProvider {
  List<AppContact> contacts = List.empty(growable: true);

  Future<void> loadAllContacts() async {
    setLoading = true;
    var phoneContacts = await FlutterContacts.getContacts(
      withPhoto: true,
      withProperties: true,
    );
    if (phoneContacts.isNotEmpty && phoneContacts.length != contacts.length) {
      phoneContacts.forEach((e) {
        contacts.add(
          AppContact(
            null,
            e.displayName,
            role: e.name.nickname,
            photoBytes: e.photo,
            email: e.emails
                .firstWhereOrNull(
                    (e) => e.address != null && e.address.isNotEmpty)
                ?.address,
            phone: e.phones
                .firstWhereOrNull(
                    (e) => e.number != null && e.number.isNotEmpty)
                ?.normalizedNumber,
          ),
        );
      });
    }
    setLoading = false;
  }

  Future<void> addImportedContacts() async {
    if (contacts.isNotEmpty) {}
  }

  updateItem(AppContact item, bool val) {
    item.selected = val;
    notifyListeners();
  }

  bool get allSelected => contacts.every((e) => e.selected);

  bool get anySelected => contacts.any((e) => e.selected);

  int get selectedCount => contacts.where((e) => e.selected).length;

  void toggleSelectAll() {
    var value = true;
    if (allSelected) {
      value = false;
    }
    contacts.forEach((e) {
      e.selected = value;
    });
    notifyListeners();
  }

  Future<void> addSelectedContacts() async {
    setLoading = true;

    var list = contacts.where((e) => e.selected).toList();
    for (int i = 0; i < list.length; i++) {
      var e = list.elementAt(i);
      await firestore
          .collection(FSKeys.usersCollection)
          .doc(username)
          .collection(FSKeys.contactsCollection)
          .add(
        {
          "name": "${e.name}",
          "email": "${e.email}",
          "phone": "${e.phone}",
          "photoUrl": "todo",
        },
      );
    }
    setLoading = false;
  }
}
