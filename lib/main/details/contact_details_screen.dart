import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kherelcontacts/main/details/edit_contact_provider.dart';
import 'package:kherelcontacts/main/main_screen.dart';
import 'package:kherelcontacts/models/app_contact.dart';
import 'package:provider/provider.dart';

class ContactDetailsScreen extends StatefulWidget {
  final AppContact item;

  ContactDetailsScreen(this.item);

  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      var editContactProvider =
          Provider.of<EditContactProvider>(context, listen: false);
      editContactProvider.setEditing = false;
      editContactProvider.setAppContact = widget.item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EditContactProvider>(
      builder: (ctx, provider, widget) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(provider.editing ? "Editing contact" : "Contact details"),
            actions: [
              if (!provider.isLoading)
                IconButton(
                  icon: Icon(
                    provider.editing
                        ? Icons.save_outlined
                        : Icons.edit_outlined,
                  ),
                  onPressed: () {
                    if (!provider.editing) {
                      provider.setEditing = true;
                    } else {
                      provider.updateContact().then((value) {
                        if (value) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (c) => MainScreen()),
                                (route) => false,
                          );
                        }
                      });
                    }
                  },
                )
            ],
          ),
          body: Center(
            child: (provider.isLoading)
                ? CupertinoActivityIndicator()
                : ListView(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    children: [
                      provider.editing
                          ? Row(
                              children: [
                                Text("Image"),
                                SizedBox(width: 16),
                                (provider.pickedFile == null &&
                                        provider.appContact.emptyPhoto)
                                    ? OutlinedButton(
                                        onPressed: () {
                                          chooseImageSourceDialog(
                                              context, provider);
                                        },
                                        child: Text(
                                          "Add photo",
                                        ),
                                      )
                                    : provider.pickedFile != null
                                        ? GestureDetector(
                                            onTap: () {
                                              deleteUpdateDialog(
                                                  context, provider);
                                            },
                                            child: Image.file(
                                              File(provider.pickedFile.path),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              deleteUpdateDialog(
                                                  context, provider);
                                            },
                                            child: FancyShimmerImage(
                                              imageUrl:
                                                  provider.appContact.photoUrl,
                                              width: 120,
                                              height: 120,
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                              ],
                            )
                          : Center(
                              child: FancyShimmerImage(
                                imageUrl: provider.appContact.photoUrl,
                                width: 120,
                                height: 120,
                                boxFit: BoxFit.cover,
                              ),
                            ),
                      SizedBox(height: 20),
                      provider.editing
                          ? TextField(
                              controller: TextEditingController(
                                  text: provider.appContact?.name ?? "")
                                ..selection = TextSelection.collapsed(
                                    offset:
                                        provider.appContact?.name?.length ?? 0),
                              decoration: InputDecoration(
                                labelText: "Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: provider.getError("name"),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onChanged: (val) => provider.setContactName = val,
                            )
                          : Text(provider.appContact?.name ?? ""),
                      SizedBox(height: 20),
                      provider.editing
                          ? TextField(
                              controller: TextEditingController(
                                  text: provider.appContact?.phone ?? "")
                                ..selection = TextSelection.collapsed(
                                    offset:
                                        provider.appContact?.phone?.length ??
                                            0),
                              decoration: InputDecoration(
                                labelText: "Phone",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: provider.getError("phone"),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onChanged: (val) => provider.setPhone = val,
                            )
                          : Text(provider.appContact?.phone ?? ""),
                      SizedBox(height: 20),
                      provider.editing
                          ? TextField(
                              controller: TextEditingController(
                                  text: provider.appContact?.email ?? "")
                                ..selection = TextSelection.collapsed(
                                    offset:
                                        provider.appContact?.email?.length ??
                                            0),
                              decoration: InputDecoration(
                                labelText: "Email",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                errorText: provider.getError("email"),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onChanged: (val) => provider.setEmail = val,
                            )
                          : Text(provider.appContact?.email ?? ""),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void deleteUpdateDialog(BuildContext context, EditContactProvider provider) {
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
      BuildContext context, EditContactProvider provider) {
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
