import 'package:mongo_dart/mongo_dart.dart' as mongo;

Future<Map<String, dynamic>> updateAddress(mongo.Db db, String email, String address) async{
  var collection = db.collection('User');
  try {
    var user = await collection.update(mongo.where.eq('email', email), mongo.modify.set('address', address));
    return {
        "success": true,
        "message": "Address changed successfully"
      };
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return {
      "success": false,
      "message": "An error occurred during change"
    };
  }
}

Future<Map<String, dynamic>> updateMotivations(mongo.Db db, String email, String motivation) async{
  var collection = db.collection('User');
  var result = await collection.find({'email': email});
  try {
    var user = await collection.update(mongo.where.eq('email', email), mongo.modify.set('motivation', motivation));
    return {
      "success": true,
      "message": "Motivation changed successfully"
    };
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return {
      "success": false,
      "message": "An error occurred during change"
    };
  }
}