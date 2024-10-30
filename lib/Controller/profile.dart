import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

Future<Map<String, dynamic>> getScore(mongo.ObjectId userId, mongo.Db db) async {
  var collection = db.collection('Score');
  try {
    var result = await collection.find({'user': userId}).toList();
    if(result.isNotEmpty) {
      return {
        'success': true,
        'data': result
      };
    } else {
      return {
        'success': false,
        'data': null,
        "message": "no score found"
      };
    }
  } catch(e) {
    return {
      'success': false,
      'data': null,
    };
  }
}

Future<Map<String, dynamic>> getUserById(mongo.Db db, mongo.ObjectId userId) async{
  var collection = db.collection('User');
  try {
    var result = await collection.findOne({'_id' : userId});

    if (result != null){
      return {
        "success": true,
        "data": result,
      };
    } else{
      return {
        "success": false,
        "data": null,
      };
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return {
      "success": false,
      "data": null,
    };
  }
}

Future<Map<String, dynamic>> getTestById(mongo.Db db, mongo.ObjectId testId) async{
  var collection = db.collection('Test');
  try {
    var result = await collection.findOne({'_id' : testId});

    if (result != null){
      return {
        "success": true,
        "data": result,
      };
    } else{
      return {
        "success": false,
        "data": null,
      };
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return {
      "success": false,
      "data": null,
    };
  }
}