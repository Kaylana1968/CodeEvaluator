import 'package:code_evaluator/Model/Category.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Category.dart';
import '../Model/Question.dart';

Future<Map<String, dynamic>> getAllTestByCategory(mongo.Db db, mongo.ObjectId categoryId) async {
  var collection = db.collection('Test');
  try {
    var results = await collection.find({
      'category': categoryId
    }).toList();

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
Future<Map<String, dynamic>> getQuestion(mongo.Db db, mongo.ObjectId? questionId) async {
  var collection = db.collection('Question');
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