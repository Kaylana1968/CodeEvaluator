import 'package:code_evaluator/Vue/question.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'Vue/add_test.dart';
import 'Vue/register.dart';
import 'Vue/Home.dart';
import 'Vue/login.dart';
import 'Vue/profile.dart';
import 'Controller/database.dart';
import 'Vue/test.dart';
import 'Vue/admin_dashboard.dart';

void main() {
  runApp(const MyApp());
}

AppBar buildCustomAppBar({required String title, List<Widget>? actions}) {
  return AppBar(
    title: Text(title),
    actions: actions,
    backgroundColor: Colors.deepPurple,
  );
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
        initialRoute: '/login',
        routes: {
          "/add-test": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AddTestPage(title: "add-test", db: snapshot.data!);
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
          "/": (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            return FutureBuilder<mongo.Db>(
              future: db,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomePage(
                    title: "Home",
                    db: snapshot.data!,
                    userId: args?['userId'] ?? mongo.ObjectId(),
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          },
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
          // In lib/main.dart
          // In lib/main.dart
          "/admin_dashboard": (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            return FutureBuilder<mongo.Db>(
              future: db,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AdminDashboardPage(
                    title: "Admin Dashboard",
                    db: snapshot.data!,
                    userId: args?['userId'] ??
                        mongo.ObjectId(), // Use the passed userId
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          },
        });
  }
}
