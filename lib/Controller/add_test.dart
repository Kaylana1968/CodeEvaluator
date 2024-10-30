import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Category.dart';
import '../Model/Question.dart';

Future<Map<String, dynamic>> createTest(mongo.Db db, String label,
    List<Question> questions, Category category) async {
  if (questions.any((question) =>
      question.choices.length < 2 ||
      !question.choices.any((choice) => choice.values.first))) {
    return {
      "success": false,
      "message": "A question must have a response and at least 2 choices!"
    };
  }

  final testCollection = db.collection('Test');
  final questionCollection = db.collection('Question');
  final categoryCollection = db.collection('Category');

  try {
    final categoryResult =
        await categoryCollection.findOne({'label': category.label});
    final mongo.ObjectId categoryId = categoryResult?['_id'];

    final List<mongo.ObjectId> questionIds = [];

    for (var i = 0; i < questions.length; i++) {
      final Question question = questions[i];
      final List<Map<String, Object>> choices = question.choices
          .map((choice) =>
              {'choiceLabel': choice.keys.first, 'isGood': choice.values.first})
          .toList();

      final questionId = mongo.ObjectId();
      questionIds.add(questionId);
      final questionJSON = {
        '_id': questionId,
        'label': question.label,
        'choices': choices,
        'category': categoryId,
      };

      await questionCollection.insert(questionJSON);
    }

    final testJson = {
      'label': label,
      'category': categoryId,
      'questions': questionIds
    };

    await testCollection.insert(testJson);

    return {"success": true, "message": "Values inserted"};
  } catch (e) {
    print("Erreur lors de l'insertion : $e");

    return {"success": false, "message": "An error occurred during insertion"};
  }
}
