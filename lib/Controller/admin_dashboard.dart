import 'package:mongo_dart/mongo_dart.dart' as mongo;

Future<Map<String, dynamic>> getScores(mongo.Db db) async {
  final collection = db.collection('Score');
  try {
    final scoreList = await collection.find().toList();
    return scoreList.isNotEmpty
        ? {
            "success": true,
            "data": scoreList,
          }
        : {"success": false, "data": null, "message": "no test found"};
  } catch (e) {
    return {"success": false, "data": null};
  }
}

Future<Map<String, dynamic>> getTest(mongo.Db db) async {
  final collection = db.collection('Test');

  try {
    final testList = await collection.find().toList();

    return testList.isNotEmpty
        ? {
            "success": true,
            "data": testList,
          }
        : {"success": false, "data": null, "message": "no test found"};
  } catch (e) {
    return {"success": false, "data": null};
  }
}
