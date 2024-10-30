import 'dart:developer';

import 'package:code_evaluator/Model/User.dart';
import 'package:code_evaluator/Model/Question.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Database {

  // Connexion a la bdd
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

   // Insérer un utilisateur (Inscription)
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

  // Verification si email est libre
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

  // Récupérer un utilisateur (Connexion)
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
     
  // Créer une question
   Future<Map<String, dynamic>> insertQuestions(mongo.Db db, Question question) async {
     var collection = db.collection('Question');
       try {
         await collection.insert(question.toMap());
         return {
           "success": true,
           "message": "Question successfully added"
         };
       } catch (e) {
         print("Erreur lors de l'insertion : $e");
         return {
           "success": false,
           "message": "An error occurred during creation of the question"
         };
       }
   }

   // Récupérer la liste des questions existantes ou une question spécifique si l'ObjectId est mis en parametres
   Future<Map<String, dynamic>> getQuestion(mongo.Db db, mongo.ObjectId ?questionId) async {
     var collection = db.collection('Questions');
     if (questionId != null){
       var question = await collection.findOne({'_id' : questionId});
       return {
         "success": true,
         "data": question,
         "message": "Question successfully added"
       };
     } else {
       var questionsList = await collection.find().toList();
       return {
         "success": true,
         "data": questionsList,
         "message": "Question successfully added"
       };
     }
   }


}