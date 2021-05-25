import 'dart:typed_data';

class AppContact {
  String id, name, role, phone, email;
  Uint8List photoBytes;
  bool selected;

  AppContact(
    this.id,
    this.name, {
    this.role,
    this.phone,
    this.email,
    this.photoBytes,
    this.selected = false,
  });
}
