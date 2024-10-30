import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';

Future<String> login(
    context, mongo.Db db, String email, String password) async {
  Map<String, dynamic> result = await getUser(db, email, password);

  if (result['success']) {
    Map<String, dynamic> resultData = result['data'];

    User user = User(
        resultData['lastName'],
        resultData['firstName'],
        resultData['password'],
        resultData['age'],
        resultData['email'],
        resultData['address'],
        resultData['motivation'],
        resultData['isAdmin']);

    Navigator.pushNamed(context, '/', arguments: user);
  }

  return result['message'];
}

// Récupérer un utilisateur (Connexion)
Future<Map<String, dynamic>> getUser(
    mongo.Db db, String email, String password) async {
  var collection = db.collection('User');
  try {
    var result =
        await collection.findOne({'email': email, 'password': password});

    if (result != null && result['_id'] is mongo.ObjectId) {
      return {
        "success": true,
        "data": result,
        "message": "Logged in as ${result['firstName']}"
      };
    } else {
      return {
        "success": false,
        "data": null,
        "message": "Incorrect email or password"
      };
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return {
      "success": false,
      "data": null,
      "message": "An error occurred during connection"
    };
  }
}
