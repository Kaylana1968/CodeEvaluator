import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'Controller/database.dart';
import 'Vue/add_test.dart';
import 'Vue/edit_test.dart';
import 'Vue/register.dart';
import 'Vue/home.dart';
import 'Vue/login.dart';
import 'Vue/profile.dart';
import 'Vue/test.dart';
import 'Vue/quiz.dart';
import 'Vue/testSelector.dart';
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
          "/": (context) {
            return FutureBuilder<mongo.Db>(
              future: db,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return HomePage(
                    title: "Home",
                    db: snapshot.data!,
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          },
          "/quiz": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return QuizPage(title: "Quiz", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/test/selector": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return TestSelectorPage(title: "Test", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
          "/admin_dashboard": (context) => FutureBuilder<mongo.Db>(
                future: db,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AdminDashboardPage(
                        title: "Admin dashboard", db: snapshot.data!);
                  }
                  return const CircularProgressIndicator();
                },
              ),
        });
  }
}
