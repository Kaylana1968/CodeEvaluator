import 'package:mongo_dart/mongo_dart.dart' as mongo;
class CategoryController {

 static Future<Map<String, dynamic>> getAllCategory(mongo.Db db) async {
    var collection = db.collection('Category');
    try {
      var results = await collection.find().toList();

      if (results.isNotEmpty) {
        return {
          "success": true,
          "data": results,
          "message": "Retrieved all records successfully"
        };
      } else {
        return {
          "success": false,
          "data": [],
          "message": "No records found"
        };
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

 static Future<mongo.ObjectId?> getCategoryIdByLabel(mongo.Db db, String label) async {
   var collection = db.collection('Category');
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

}