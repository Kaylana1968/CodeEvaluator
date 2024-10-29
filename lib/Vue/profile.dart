import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

const List<String> motivations = [
  "Poursuite d'études",
  "Reconversion professionnelle",
  "Réorientation"
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required mongo.Db db});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String motivationValue = motivations.first;

  String lastName = "monNom";
  String firstName = "monPrenom";
  int age = 20;
  String email = "monMail@gmail.com";
  String address = "maMaison";
  String motivation = "maMotivation";

  Widget modifyAddress() {
    return Column(children: [
      TextFormField(
        decoration: const InputDecoration(
          labelText: "Modify Address",),
        validator: (value) => value!.isEmpty ? 'Enter your last name' : null,
      ),
      ElevatedButton(
          child: const Text('Modify'),
          onPressed: () => ()
      )
    ]
    );
  }


  Widget modifyMotivation() {
    return Column(children: [
      DropdownButton(
          isExpanded: true,
          value: motivationValue,
          items: motivations.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            motivationValue = value!;
          })),
      ElevatedButton(
          child: const Text('Modify'),
          onPressed: () => ()
      )
    ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        // width: double.infinity,
        // margin: const EdgeInsets.all(16.0),
          children: [ Card(
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
                    Text("$firstName $lastName"),
                    Text(age.toString()),
                    Text(address),
                    Text(email),
                    Text(motivation),
                  ],
                ),
              )
          ),
            Form(child: modifyAddress()),
            Form(child: modifyMotivation())

          ]
      ),
    );
  }
}
