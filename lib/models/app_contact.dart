import 'dart:typed_data';

class AppContact {
  String id, name, role, phone, email, photoUrl;
  Uint8List photoBytes;
  bool selected;

  AppContact(
    this.id,
    this.name, {
    this.role,
    this.phone,
    this.email,
    this.photoBytes,
    this.photoUrl,
    this.selected = false,
  });

  bool get emptyPhoto => photoUrl == null || photoUrl.isEmpty;
}
