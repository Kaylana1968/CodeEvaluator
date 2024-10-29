import 'package:flutter/material.dart';

import '../Model/User.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  User user = User("monNom","monPrenom","password",4,"monMail@gmail.com","maMaison","maMotivation",false);
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
              margin: const EdgeInsets.all(10.0),
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
                    Text("${user.firstName} ${user.lastName}"),
                    Text(user.age.toString()),
                    Text(user.address),
                    Text(user.email),
                    Text(user.motivation),
                  ],
                ),
              )
          )
      ),
    );
  }
}
