import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kherelcontacts/main.dart';
import 'package:kherelcontacts/main/add_contact/add_contact.dart';
import 'package:kherelcontacts/main/main_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        padding: EdgeInsets.all(16),
                        itemCount: snapshot.data.size,
                        itemBuilder: (ctx, index) {
                          QueryDocumentSnapshot item =
                              snapshot.data.docs.elementAt(index);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 32,
                              child: FancyShimmerImage(
                                imageUrl: item.get("photoUrl"),
                              ),
                            ),
                            title: Text(item.get("name") ?? ""),
                            subtitle: Text(item.get("phone") ?? ""),
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
