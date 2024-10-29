import 'package:flutter/material.dart';

import 'Vue/register.dart';
import 'Vue/login.dart';
import 'Vue/profile.dart';
import 'Controller/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Database database = Database();
    database.connectToDatabase();

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/register',
        routes: {
          "/register": (context) => const RegistrationPage(title: "Register"),
          "/login": (context) => const LoginPage(title: "Log in"),
          "/profile": (context) => const ProfilePage(title: "profile")
        });
  }
}
