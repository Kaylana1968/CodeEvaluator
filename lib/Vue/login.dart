import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/database.dart';
import '../Controller/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget formInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Database();
    Map<String, dynamic> result;
    mongo.ObjectId userId;
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
                    result = await database.getUser(widget.db, emailController.text, passwordController.text);
                    if (result['success']) {
                      userId = result['data'];
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
                child: const Text('Register'),
                onPressed: () => (Navigator.pushNamed(context, '/register')),
              ),
            ],
          )),
    );
  }
}
