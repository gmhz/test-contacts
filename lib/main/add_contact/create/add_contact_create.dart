import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kherelcontacts/main/add_contact/create/add_contact_create_provider.dart';
import 'package:kherelcontacts/main/main_screen.dart';
import 'package:provider/provider.dart';

class AddContactCreateScreen extends StatefulWidget {
  const AddContactCreateScreen({Key key}) : super(key: key);

  @override
  _AddContactCreateScreenState createState() => _AddContactCreateScreenState();
}

class _AddContactCreateScreenState extends State<AddContactCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddContactCreateProvider>(
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
                          OutlinedButton(
                            onPressed: () {
                            },
                            child: Text(
                              "Add photo",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton.extended(
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
                        backgroundColor: Colors.grey,
                        label: Container(
                          width: 120,
                          child: Text("Create", textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
