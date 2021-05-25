import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kherelcontacts/auth/auth_provider.dart';
import 'package:kherelcontacts/auth/auth_screen.dart';
import 'package:kherelcontacts/main/add_contact/create/create_contact_provider.dart';
import 'package:kherelcontacts/main/add_contact/import/add_contact_import_provider.dart';
import 'package:kherelcontacts/main/details/edit_contact_provider.dart';
import 'package:kherelcontacts/main/main_provider.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AddContactImportProvider()),
        ChangeNotifierProvider(create: (_) => CreateContactProvider()),
        ChangeNotifierProvider(create: (_) => EditContactProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String> _userSupscription;

  @override
  void initState() {
    super.initState();

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var addContactProvider =
        Provider.of<AddContactImportProvider>(context, listen: false);
    var mainProvider = Provider.of<MainProvider>(context, listen: false);
    var createContactProvider =
        Provider.of<CreateContactProvider>(context, listen: false);
    var editContactProvider = Provider.of<EditContactProvider>(context, listen: false);
    _userSupscription = authProvider.userStream.stream.listen((value) {
      addContactProvider.setUsername = value;
      mainProvider.setUsername = value;
      createContactProvider.setUsername = value;
      editContactProvider.setUsername = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userSupscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: AuthScreen(),
    );
  }
}
