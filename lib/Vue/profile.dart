import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String lastName = "monNom";
  String firstName = "monPrenom";
  int age = 20;
  String email = "monMail@gmail.com";
  String address = "maMaison";
  String motivation = "maMotivation";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Card(
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 50,
                    ),
                    Text("$firstName $lastName"),
                    Text(age.toString()),
                    Text(address),
                    Text(email),
                    Text(motivation),
                  ],
                ),
              ))),
    );
  }
}
