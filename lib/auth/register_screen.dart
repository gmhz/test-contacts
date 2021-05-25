import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kherelcontacts/auth/auth_provider.dart';
import 'package:kherelcontacts/main.dart';
import 'package:kherelcontacts/main/main_screen.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).clearErrors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AuthProvider>(
        builder: (ctx, provider, widget) {
          return Scaffold(
            body: Center(
              child: (provider.isLoading)
                  ? CupertinoActivityIndicator()
                  : ListView(
                      padding: EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller:
                              TextEditingController(text: provider.username)
                                ..selection = TextSelection.collapsed(
                                    offset: provider.username?.length ?? 0),
                          decoration: InputDecoration(
                            errorText: provider.getError("username"),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 5.0),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[A-Za-z0-9]'))
                          ],
                          onChanged: (val) => provider.setUsername = val,
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: () {
                            provider.createUserIfNotExists().then((value) {
                              print(
                                  "provider.checkAndAuthIfUserExists result: $value");
                              if (value) {
                                Navigator.push(
                                  navigatorKey.currentContext,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              }
                            });
                          },
                          child: Text(
                            "Create account",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
