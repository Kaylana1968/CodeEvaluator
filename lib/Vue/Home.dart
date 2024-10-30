import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/header.dart';
import '../Model/User.dart';

class HomePage extends StatefulWidget {
  final String title;
  final mongo.Db db;
  final mongo.ObjectId userId;

  const HomePage(
      {super.key, required this.title, required this.db, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    var collection = widget.db.collection('User');
    var userData = await collection.findOne(mongo.where.id(widget.userId));
    setState(() {
      if (userData != null) {
        user = User.fromMap(userData);
      } else {
        user = User("monNom", "monPrenom", "password", 4, "monMail@gmail.com",
            "maMaison", "maMotivation", false);
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: headerDisplay(context, widget.title, false),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: headerDisplay(context, widget.title, false),
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
                onPressed: () => (Navigator.pushNamed(context, '/test')),
                child: const Text("Evaluation")),
            const SizedBox(height: 40.0),
            ElevatedButton(
                onPressed: () => (Navigator.pushNamed(context, '/profile')),
                child: const Text("Graphic")),
            const SizedBox(height: 40.0),
            // In lib/Vue/Home.dart
            if (user.admin)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/admin_dashboard',
                    arguments: {
                      'userId': widget.userId, // Pass the correct userId
                    },
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
