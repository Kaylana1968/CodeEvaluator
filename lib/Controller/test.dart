import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Question.dart';

Future<Map<String, dynamic>> createTest(mongo.Db db, String label,
    List<Question> questions, Map<String, dynamic> category) async {
  if (questions.isEmpty ||
      questions.any((question) =>
          question.choices.length < 2 ||
          !question.choices.any((choice) => choice.isGood))) {
    return {
      "success": false,
      "message": "A test must have questions that have a response and at least 2 choices!"
    };
  }

  final testCollection = db.collection('Test');
  final questionCollection = db.collection('Question');

  try {
    final List<mongo.ObjectId> questionIds = [];

    for (var i = 0; i < questions.length; i++) {
      final Question question = questions[i];
      final List<Map<String, Object>> choices = question.choices
          .map((choice) =>
              {'choiceLabel': choice.choiceLabel, 'isGood': choice.isGood})
          .toList();

      final questionId = mongo.ObjectId();
      questionIds.add(questionId);
      final questionJSON = {
        '_id': questionId,
        'label': question.label,
        'choices': choices,
        'category': category['_id'],
      };

      await questionCollection.insert(questionJSON);
    }

    final testJson = {
      'label': label,
      'category': category['_id'],
      'questions': questionIds
    };

    await testCollection.insert(testJson);

    return {"success": true, "message": "Values inserted"};
  } catch (e) {
    print("Erreur lors de l'insertion : $e");

    return {"success": false, "message": "An error occurred during insertion"};
  }
}

Future<Map<String, dynamic>> getTest(mongo.Db db, mongo.ObjectId testId) async {
  final collection = db.collection('Test');

  try {
    final results = await collection.findOne({'_id': testId});

    return {
      "success": true,
      "data": results,
      "message": "Retrieved all records successfully"
    };
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return {
      "success": false,
      "data": null,
      "message": "An error occurred during connection"
    };
  }
}
