import 'package:flutter/material.dart';
import '../Controller/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

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
                  onPressed: () {
                    login(emailController.text, passwordController.text);
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
