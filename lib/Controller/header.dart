import 'package:flutter/material.dart';

 AppBar headerDisplay(BuildContext context, String title) {
   return AppBar(
     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
     title: Text(title),
     actions: [
       IconButton(
         style: IconButton.styleFrom(backgroundColor: Colors.deepPurple,
           foregroundColor: Colors.black,
         ),
         onPressed: () => (Navigator.pushNamed(context, '/profile')),
         icon: const Icon(
           Icons.person,
           size: 30,
         ),
       ),
     ],
   );
 }