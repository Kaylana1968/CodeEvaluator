import 'package:code_evaluator/Vue/question.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'Vue/add_test.dart';
import 'Vue/edit_test.dart';
import 'Vue/register.dart';
import 'Vue/Home.dart';
import 'Vue/login.dart';
import 'Vue/profile.dart';
import 'Controller/database.dart';
import 'Vue/test.dart';

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
        initialRoute: '/edit-test',
        routes: {
          "/add-test": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AddTestPage(title: "Register", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/edit-test": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return EditTestPage(title: "Register", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/register": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RegistrationPage(
                        title: "Register", db: snapshot.data!);
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
          "/profile": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ProfilePage(title: "Profile", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/test": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return TestPage(title: "Test", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return HomePage(title: "Home", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/evaluation": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return QuestionPage(
                        title: "Evaluation", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
        });
  }
}
