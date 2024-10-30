import 'dart:developer';

import 'package:code_evaluator/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Database {
   Future<mongo.Db> connectToDatabase() async {
    var encryptedPassword = Uri.encodeComponent('root');
    var db = await mongo.Db.create(
        'mongodb+srv://root:$encryptedPassword@cluster0.dtna3.mongodb.net/CodeEvaluator?retryWrites=true&w=majority&appName=Cluster0');
    print('Connexion à la bdd...');
    try {
      await db.open();
      print('Connexion réussie');
      print(db.databaseName);
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
    }
    return db;
  }

   Future<Map<String, dynamic>> insertUser(mongo.Db db, User user) async{
    var collection = db.collection('User');
    if (await isUniqueEmail(db, user)){
      try {
        await collection.insert(user.toMap());
        return {
          "success": true,
          "message": "Registered as ${user.firstName}"
        };
      } catch (e) {
        print("Erreur lors de l'insertion : $e");
        return {
          "success": false,
          "message": "An error occurred during registration"
        };
      }
    } else {
      return {
        "success": false,
        "message": "Email already used"
      };
    }
  }

  Future<bool> isUniqueEmail(mongo.Db db, User user) async{
    var collection = db.collection('User');
      try {
      var result = await collection.findOne({'email' : user.email});
      return result == null;
    } catch (e) {
      print('Erreur lors de la récupération : $e');
    }
    return false;
  }


   Future<Map<String, dynamic>> getUser(mongo.Db db, String email,String password) async{
    var collection = db.collection('User');
    try {
      var result = await collection.findOne({'email' : email, 'password' : password});

      if (result != null && result['_id'] is mongo.ObjectId){
        return {
          "success": true,
          "data": result['_id'],
          "message": "Logged in as ${result['firstName']}"
        };
      } else{
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

   Future<Map<String, dynamic>> getAllTestByCategory(mongo.Db db, String category) async{
     var collection = db.collection('Test');
     try {
       var results = await collection.find({'category' : category}).toList();

       if (results.isNotEmpty) {
         return {
           "success": true,
           "data": results,
           "message": "Retrieved all records successfully"
         };
       } else {
         return {
           "success": false,
           "data": [],
           "message": "No records found"
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




}