import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kherelcontacts/auth/auth_provider.dart';
import 'package:kherelcontacts/auth/auth_screen.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
