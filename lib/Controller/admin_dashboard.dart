import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';

Future<Map<String, dynamic>> getScores(mongo.Db db, mongo.ObjectId ?userId) async {
  var collection = db.collection('Score');
  if (userId != null){
    var scoreList = await collection.find({'user' : userId}).toList();
    return {
      "success": true,
      "data": scoreList,
    };
  } else {
    var scoreList = await collection.find().toList();
    return {
      "success": true,
      "data": scoreList
    };
  }
}
