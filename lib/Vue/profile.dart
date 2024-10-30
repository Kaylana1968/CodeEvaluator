import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';
import 'package:code_evaluator/Controller/profile.dart';

const List<String> motivations = [
  "Poursuite d'études",
  "Reconversion professionnelle",
  "Réorientation"
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController addressController = TextEditingController();
  String motivationValue = motivations.first;
  User user = User("monNom","monPrenom","password",4,"email","maMaison","maMotivation",false);
  Widget modifyAddress() {
    Map<String, dynamic> result;
    return Column(children: [
      TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          labelText: "Modify Address",),
        validator: (value) => value!.isEmpty ? 'Enter your last name' : null,
      ),
      ElevatedButton(
          child: const Text('Modify'),
          onPressed: () async {
            result = await updateAddress(widget.db, user.email, addressController.text);
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${result['message']}")),
          );
          }
        )
    ]
    );
  }


  Widget modifyMotivation() {
    Map<String, dynamic> result;
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
          onPressed: () async {
            result = await updateMotivations(widget.db, user.email, motivationValue);
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${result['message']}")),
            );
          }
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
                    Text("${user.firstName} ${user.lastName}"),
                    Text(user.age.toString()),
                    Text(user.address),
                    Text(user.email),
                    Text(user.motivation),
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
