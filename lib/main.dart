import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

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
    var db = database.connectToDatabase();

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/register',
        routes: {
          "/register": (context) => FutureBuilder<mongo.Db>(
            future: db,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RegistrationPage(title: "Register", db: snapshot.data!);
              }
              return const CircularProgressIndicator();
            },
          ),
          "/login": (context) => FutureBuilder<mongo.Db>(
            future: db,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LoginPage(title: "Login", db: snapshot.data!);
              }
              return const CircularProgressIndicator();
            },
          ),
          "/profile": (context) => const ProfilePage(title: "profile")
        });
  }
}
