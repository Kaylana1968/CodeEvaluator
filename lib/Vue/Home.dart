import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/header.dart';
import '../Model/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required mongo.Db db});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  User user = User("monNom","monPrenom","password",4,"monMail@gmail.com","maMaison","maMotivation",false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerDisplay(context, widget.title),
      body: Container(
        width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Column(
              children: [Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello ${user.firstName}",
                      style: const TextStyle(fontSize: 30)
                  ),
                ],
              ),
                const SizedBox(height: 70.0),
                ElevatedButton(onPressed: () => (Navigator.pushNamed(context, '/test')),
                    child: const Text("Evaluation")
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(onPressed: () => (Navigator.pushNamed(context, '/profile')),
                    child: const Text("Graphic")
                ),
              ]
          )
      ),
    );
  }
}