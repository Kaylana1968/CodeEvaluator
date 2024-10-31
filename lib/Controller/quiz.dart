import 'package:mongo_dart/mongo_dart.dart' as mongo;

// Récupérer la liste des questions existantes ou une question spécifique si l'ObjectId est mis en parametres
Future<Map<String, dynamic>> getTestByLabel(
    mongo.Db db, String testLabel) async {
  final collection = db.collection('Test');
  final test = await collection.findOne({'label': testLabel});

  return {"success": true, "data": test, "message": "successfully get test"};
}

Future<mongo.ObjectId?> getTestIdByLabel(mongo.Db db, String label) async {
  final collection = db.collection('Test');

  try {
    final result = await collection.findOne(mongo.where.eq('label', label));

    return result != null ? result['_id'] : null;
  } catch (e) {
    print('Erreur lors de la récupération de l\'ID : $e');
    return null;
  }
}

Future<mongo.ObjectId?> getQuestionIdByLabel(mongo.Db db, String label) async {
  var collection = db.collection('Question');
  try {
    var result = await collection.findOne(mongo.where.eq('label', label));

    if (result != null) {
      return result['_id'];
    } else {
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération de l\'ID : $e');
    return null;
  }
}

Future<Map<String, dynamic>> insertScore(mongo.Db db, result) async {
  var collection = db.collection('Score');
  try {
    await collection.insert(result);
    return {"success": true, "message": "Score inserted successfully"};
  } catch (e) {
    print("Erreur lors de l'insertion : $e");
    return {"success": false, "message": "An error occurred during insertion"};
  }
}
