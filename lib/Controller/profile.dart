import 'package:mongo_dart/mongo_dart.dart' as mongo;

Future<Map<String, dynamic>> updateAddress(
    mongo.Db db, String email, String address) async {
  final collection = db.collection('User');

  try {
    await collection.update(
        mongo.where.eq('email', email), mongo.modify.set('address', address));

    return {"success": true, "message": "Address changed successfully"};
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return {"success": false, "message": "An error occurred during change"};
  }
}

Future<Map<String, dynamic>> updateMotivations(
    mongo.Db db, String email, String motivation) async {
  final collection = db.collection('User');

  try {
    await collection.update(mongo.where.eq('email', email),
        mongo.modify.set('motivation', motivation));

    return {"success": true, "message": "Motivation changed successfully"};
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return {"success": false, "message": "An error occurred during change"};
  }
}

Future<Map<String, dynamic>> getScore(
    mongo.ObjectId userId, mongo.Db db) async {
  final collection = db.collection('Score');

  try {
    final result = await collection.find({'user': userId}).toList();

    return result.isNotEmpty
        ? {'success': true, 'data': result}
        : {'success': false, 'data': null, "message": "no score found"};
  } catch (e) {
    return {
      'success': false,
      'data': null,
    };
  }
}

Future<Map<String, dynamic>> getUserById(
    mongo.Db db, mongo.ObjectId userId) async {
  final collection = db.collection('User');
  try {
    final result = await collection.findOne({'_id': userId});

    return {
      "success": result != null,
      "data": result,
    };
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return {
      "success": false,
      "data": null,
    };
  }
}

Future<Map<String, dynamic>> getTestById(
    mongo.Db db, mongo.ObjectId testId) async {
  final collection = db.collection('Test');

  try {
    final result = await collection.findOne({'_id': testId});

    return {
      "success": result != null,
      "data": result,
    };
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return {
      "success": false,
      "data": null,
    };
  }
}

Future<mongo.ObjectId?> getUserIdByEmail(mongo.Db db, String email) async {
  final collection = db.collection('User');
  try {
    final result = await collection.findOne({'email': email});

    return result?['_id'];
  } catch (e) {
    print('Erreur lors de la récupération : $e');

    return null;
  }
}
