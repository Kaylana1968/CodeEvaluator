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
  final categoryCollection = db.collection('Category');
  try {
    var results = await collection.find().toList();

    if (results.isNotEmpty) {
      Future<List<Question>> getQuestions() async {
        List<Future<Question>> futures = (results.map((object) async {
          final categoryResult =
              await categoryCollection.findOne({'_id': object['category']});
          Category category = Category(categoryResult?['label']);

          return Question(
              object['label'],
              List<Map<String, bool>>.from(object['choices'].map((answer) => {
                    answer['choiceLabel']: answer['isGood']
                  }.cast<String, bool>())),
              category);
        }).toList());

        return await Future.wait(futures);
      }

      List<Question> questions = await getQuestions();

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
  var collection = db.collection('Category');
  try {
    var results = await collection.find().toList();

    if (results.isNotEmpty) {
      List<Category> categories = List<Category>.from(
          results.map((object) => Category(object['label'])).toList());

      return {
        "success": true,
        "data": categories,
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
