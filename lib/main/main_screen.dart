import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kherelcontacts/main.dart';
import 'package:kherelcontacts/main/add_contact/add_contact.dart';
import 'package:kherelcontacts/main/details/contact_details_screen.dart';
import 'package:kherelcontacts/main/main_provider.dart';
import 'package:kherelcontacts/models/app_contact.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main page"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            navigatorKey.currentContext,
            MaterialPageRoute(
              builder: (context) => AddContactScreen(),
            ),
          );
        },
        backgroundColor: Colors.grey,
        label: Container(
          width: 120,
          child: Text("Add new", textAlign: TextAlign.center),
        ),
      ),
      body: Consumer<MainProvider>(
        builder: (ctx, provider, widget) {
          return Center(
            child: (provider.isLoading)
                ? CupertinoActivityIndicator()
                : StreamBuilder<QuerySnapshot>(
                    stream: provider.myContactsLive(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return CupertinoActivityIndicator();

                      return ListView.builder(
                        itemCount: snapshot.data.size,
                        itemBuilder: (ctx, index) {
                          QueryDocumentSnapshot item =
                              snapshot.data.docs.elementAt(index);
                          String name = item.get("name") ?? "";
                          String phone = item.get("phone") ?? "";

                          String firstLetter =
                              name.isNotEmpty ? name.substring(0, 1) : " ";
                          return ListTile(
                            onTap: () {
                              var name = item.get('name');
                              var phone = item.get('phone');
                              var email = item.get('email');
                              var photoUrl = item.get('photoUrl');
                              var id = item.reference.id;
                              Navigator.push(
                                navigatorKey.currentContext,
                                MaterialPageRoute(
                                  builder: (context) => ContactDetailsScreen(
                                    AppContact(
                                      id,
                                      name,
                                      phone: phone,
                                      email: email,
                                      photoUrl: photoUrl,
                                    ),
                                  ),
                                ),
                              );
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FancyShimmerImage(
                                imageUrl: item.get("photoUrl"),
                                width: 32,
                                height: 32,
                                errorWidget: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    firstLetter,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(name),
                            subtitle: Text(phone),
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
