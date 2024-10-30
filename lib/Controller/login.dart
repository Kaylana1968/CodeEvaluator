import 'package:mongo_dart/mongo_dart.dart' as mongo;

void login(String email, String password) {}
// Récupérer un utilisateur (Connexion)
Future<Map<String, dynamic>> getUser(mongo.Db db, String email,String password) async{
  var collection = db.collection('User');
  try {
    var result = await collection.findOne({'email' : email, 'password' : password});

    if (result != null && result['_id'] is mongo.ObjectId){
      return {
        "success": true,
        "data": result['_id'],
        "message": "Logged in as ${result['firstName']}"
      };
    } else{
      return {
        "success": false,
        "data": null,
        "message": "Incorrect email or password"
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
