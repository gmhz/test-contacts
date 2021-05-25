import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kherelcontacts/main.dart';
import 'package:kherelcontacts/main/add_contact/create/create_contact.dart';
import 'package:kherelcontacts/main/add_contact/import/add_contact_import.dart';

class AddContactScreen extends StatelessWidget {
  const AddContactScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new contact"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: Size.fromHeight(height * .21),
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  Navigator.push(
                    navigatorKey.currentContext,
                    MaterialPageRoute(
                      builder: (context) => CreateContactScreen(),
                    ),
                  );
                },
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: Size.fromHeight(height * .21),
                  alignment: Alignment.center,
                ),
                onPressed: () {
                  FlutterContacts.requestPermission().then((value) {
                    if (value)
                      Navigator.push(
                        navigatorKey.currentContext,
                        MaterialPageRoute(
                          builder: (context) => AddContactImportScreen(),
                        ),
                      );
                  });
                },
                child: Text(
                  "Import from phone",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
