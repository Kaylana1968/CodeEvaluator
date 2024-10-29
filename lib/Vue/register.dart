import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/register.dart';
import '../Model/User.dart';
import '../Controller/database.dart';

const List<String> motivations = [
  "Poursuite d'études",
  "Reconversion professionnelle",
  "Réorientation"
];

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String motivationValue = motivations.first;


  Widget formInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Last name",
          ),
          controller: lastNameController,
          validator: (value) => value!.isEmpty ? 'Enter your last name' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "First name",
          ),
          controller: firstNameController,
          validator: (value) => value!.isEmpty ? 'Enter your first name' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Email",
          ),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          validator: (value) => value!.isEmpty ? 'Enter your email' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Password",
          ),
          controller: passwordController,
          validator: (value) => value!.isEmpty ? 'Enter your password' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Address",
          ),
          controller: addressController,
          validator: (value) => value!.isEmpty ? 'Enter your address' : null,
        ),
        TextFormField(
            decoration: const InputDecoration(
              labelText: "Age",
            ),
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Enter your age' : null),
        const SizedBox(height: 8.0),
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
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Database();
    Map<String, dynamic> result;
    User newUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(child: formInput()),
              const SizedBox(height: 8.0),
              ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () async {
                    newUser = User(lastNameController.text, firstNameController.text, passwordController.text, ageController.hashCode, emailController.text, addressController.text, motivationValue, false);
                    result = await database.insertUser(widget.db, newUser);
                    if (result['success']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${result['message']}")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${result['message']}")),
                      );
                    }
                  }),
              ElevatedButton(
                  child: const Text('Log in'),
                  onPressed: () => (Navigator.pushNamed(context, '/login'))),
            ],
          )),
    );
  }
}
