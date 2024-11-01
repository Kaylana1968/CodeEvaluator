import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'header.dart';
import '../Model/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = User("", "", "", 0, "", "", "", false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as User?;

    if (args == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      user = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerDisplay(context, widget.title, false, user),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hello ${user.firstName}",
                    style: const TextStyle(fontSize: 30)),
              ],
            ),
            const SizedBox(height: 70.0),
            ElevatedButton(
                onPressed: () =>
                    (Navigator.pushNamed(context, '/test', arguments: user)),
                child: const Text("Pass a Test")),
            const SizedBox(height: 40.0),
            if (user.admin)
              ElevatedButton(
                  onPressed: () => (Navigator.pushNamed(context, '/profile', arguments: user)),
                  child: const Text("Graphic")),
            const SizedBox(height: 40.0),
            if (user.admin)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/admin_dashboard',
                    arguments: user,
                  );
                },
                child: const Text("Admin Dashboard"),
              ),
          ],
        ),
      ),
    );
  }
}
