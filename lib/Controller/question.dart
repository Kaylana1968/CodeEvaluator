import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Category.dart';
import '../Model/Question.dart';

Future<Map<String, dynamic>> getAllTestByCategory(
    mongo.Db db, Category category) async {
  var collection = db.collection('Test');
  try {
    var categoryId = await collection.findOne({'label': category.label});
    var results =
        await collection.find({'category': categoryId?['_id']}).toList();

    if (results.isNotEmpty) {
      return {
        "success": true,
        "data": results,
        "message": "Retrieved all records successfully"
      };
    } else {
      return {"success": false, "data": [], "message": "No records found"};
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

Future<Map<String, dynamic>> getAllQuestion(mongo.Db db) async {
  final collection = db.collection('Question');
  try {
    final results = await collection.find().toList();

    if (results.isNotEmpty) {
      List<Question> questions = results.map((object) {
        return Question(
            object['label'],
            List<Choice>.from(object['choices'].map(
                (choice) => Choice(choice['choiceLabel'], choice['isGood']))),
            object['category']);
      }).toList();

      return {
        "success": true,
        "data": questions,
        "message": "Retrieved all records successfully"
      };
    } else {
      return {"success": false, "data": [], "message": "No records found"};
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

Future<Map<String, dynamic>> getAllCategory(mongo.Db db) async {
  final collection = db.collection('Category');
  try {
    final results = await collection.find().toList();

    if (results.isNotEmpty) {
      return {
        "success": true,
        "data": results,
        "message": "Retrieved all records successfully"
      };
    } else {
      return {"success": false, "data": [], "message": "No records found"};
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

// Récupérer la liste des questions existantes ou une question spécifique si l'ObjectId est mis en parametres
Future<Map<String, dynamic>> getQuestion(
    mongo.Db db, mongo.ObjectId? questionId) async {
  var collection = db.collection('Questions');
  if (questionId != null) {
    var question = await collection.findOne({'_id': questionId});
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
