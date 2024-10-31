import 'package:flutter/material.dart';

import '../Model/User.dart';

AppBar headerDisplay(BuildContext context, String title, bool BackButton, User ?user) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    title: Text(title),
    automaticallyImplyLeading: BackButton,
    actions: [
      IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.black,
        ),
        onPressed: () => (Navigator.pushNamed(context, '/profile', arguments: user)),
        icon: const Icon(
          Icons.person,
          size: 30,
        ),
      ),
    ],
  );
}
