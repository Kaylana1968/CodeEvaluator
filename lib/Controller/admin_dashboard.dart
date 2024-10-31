import 'package:mongo_dart/mongo_dart.dart' as mongo;

Future<Map<String, dynamic>> getScores(mongo.Db db) async {
  var collection = db.collection('Score');
  try {
    var scoreList = await collection.find().toList();
    if (scoreList.isNotEmpty) {
      return {
        "success": true,
        "data": scoreList,
      };
    } else {
      return {"success": false, "data": null, "message": "no test found"};
    }
  } catch (e) {
    return {"success": false, "data": null};
  }
}

Future<Map<String, dynamic>> getTest(mongo.Db db) async {
  var collection = db.collection('Test');
  try {
    var testList = await collection.find().toList();
    if (testList.isNotEmpty) {
      return {
        "success": true,
        "data": testList,
      };
    } else {
      return {"success": false, "data": null, "message": "no test found"};
    }
  } catch (e) {
    return {"success": false, "data": null};
  }
}
