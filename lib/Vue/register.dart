import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/register.dart';
import 'package:code_evaluator/Controller/register.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _motivationValue = motivations.first;


  Widget formInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Last name",
          ),
          controller: _lastNameController,
          validator: (value) => value!.isEmpty ? 'Enter your last name' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "First name",
          ),
          controller: _firstNameController,
          validator: (value) => value!.isEmpty ? 'Enter your first name' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Email",
          ),
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          validator: (value) {
            final emailRegex =
                RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

            if (value!.isEmpty) {
              return 'Enter your email';
            } else if (!emailRegex.hasMatch(value)) {
              return 'Enter a valid email';
            }

            return null;
          },
        ),
        TextFormField(
            decoration: const InputDecoration(
              labelText: "Password",
            ),
            controller: _passwordController,
            validator: (value) {
              final passwordRegex = RegExp(
                  r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

              if (value!.isEmpty) {
                return 'Enter your password';
              } else if (!passwordRegex.hasMatch(value)) {
                return 'Enter a better password';
              }

              return null;
            }),
        TextFormField(
            decoration: const InputDecoration(
              labelText: "Confirm password",
            ),
            controller: _confirmPasswordController,
            validator: (value) => value!.isEmpty ? 'Enter your address' : null),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Address",
          ),
          controller: _addressController,
          validator: (value) => value!.isEmpty ? 'Enter your address' : null,
        ),
        TextFormField(
            decoration: const InputDecoration(
              labelText: "Age",
            ),
            controller: _ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              final numberRegex = RegExp(r"^\d+$");

              if (value!.isEmpty) {
                return 'Enter your age';
              } else if (!numberRegex.hasMatch(value)) {
                return "Enter a number";
              }

              return null;
            }),
        const SizedBox(height: 8.0),
        DropdownButton(
            isExpanded: true,
            value: _motivationValue,
            items: motivations.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) => setState(() {
                  _motivationValue = value!;
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Form(key: _formKey, child: formInput()),
              const SizedBox(height: 8.0),
              ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      newUser = User(_lastNameController.text, _firstNameController.text, _passwordController.text, _ageController.hashCode, _emailController.text, _addressController.text, _motivationValue, false);
                      result = await insertUser(widget.db, newUser);
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
