import 'package:code_evaluator/Model/Category.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:code_evaluator/Model/Question.dart';

Future<Map<String, dynamic>> getAllTestByCategory(mongo.Db db, Category category) async {
  var collection = db.collection('Test');
  try {
    var categoryId = await collection.findOne({'label' : category.label});
    var results = await collection.find({'category': categoryId?['_id']}).toList();

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