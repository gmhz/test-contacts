import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kherelcontacts/main/add_contact/create/create_contact_provider.dart';
import 'package:kherelcontacts/main/main_screen.dart';
import 'package:provider/provider.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({Key key}) : super(key: key);

  @override
  _CreateContactScreenState createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateContactProvider>(
      builder: (ctx, provider, widget) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Create contact"),
          ),
          body: Center(
            child: (provider.isLoading)
                ? CupertinoActivityIndicator()
                : ListView(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    children: [
                      TextField(
                        controller: TextEditingController(
                            text: provider.appContact?.name ?? "")
                          ..selection = TextSelection.collapsed(
                              offset: provider.appContact?.name?.length ?? 0),
                        decoration: InputDecoration(
                          labelText: "Name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorText: provider.getError("name"),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (val) => provider.setContactName = val,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: TextEditingController(
                            text: provider.appContact?.phone ?? "")
                          ..selection = TextSelection.collapsed(
                              offset: provider.appContact?.phone?.length ?? 0),
                        decoration: InputDecoration(
                          labelText: "Phone",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorText: provider.getError("phone"),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (val) => provider.setPhone = val,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: TextEditingController(
                            text: provider.appContact?.email ?? "")
                          ..selection = TextSelection.collapsed(
                              offset: provider.appContact?.email?.length ?? 0),
                        decoration: InputDecoration(
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorText: provider.getError("email"),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onChanged: (val) => provider.setEmail = val,
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Image"),
                          SizedBox(width: 16),
                          (provider.pickedFile == null)
                              ? OutlinedButton(
                                  onPressed: () {
                                    chooseImageSourceDialog(context, provider);
                                  },
                                  child: Text(
                                    "Add photo",
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    deleteUpdateDialog(context, provider);
                                  },
                                  child: Image.file(
                                    File(provider.pickedFile.path),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          provider.createContact().then((value) {
                            if (value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => MainScreen()),
                                (route) => false,
                              );
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: Container(
                          width: 120,
                          child: Text(
                            "Create",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void deleteUpdateDialog(
      BuildContext context, CreateContactProvider provider) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
              ),
              title: Text("Update photo"),
              onTap: () async {
                Navigator.of(context).pop();
                chooseImageSourceDialog(context, provider);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
              ),
              title: Text("Delete photo"),
              onTap: () async {
                Navigator.of(context).pop();
                provider.setPickedFile = null;
              },
            ),
            ListTile(
              leading: Icon(
                Icons.cancel_outlined,
              ),
              title: Text("Cancel"),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void chooseImageSourceDialog(
      BuildContext context, CreateContactProvider provider) {
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
              ),
              title: Text("Camera"),
              onTap: () async {
                Navigator.of(context).pop();
                provider.setPickedFile = await ImagePicker().getImage(
                  source: ImageSource.camera,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
              ),
              title: Text("Gallery"),
              onTap: () async {
                Navigator.of(context).pop();
                provider.setPickedFile = await ImagePicker().getImage(
                  source: ImageSource.gallery,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.cancel_outlined,
              ),
              title: Text("Cancel"),
              onTap: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
