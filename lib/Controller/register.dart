import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:code_evaluator/Model/User.dart';

void register(
  String lastName,
  String firstName,
  String email,
  String password,
  String confirmPassword,
  String address,
  String age,
  String motivation,
) {}

// Insérer un utilisateur (Inscription)
Future<Map<String, dynamic>> insertUser(mongo.Db db, User user) async{
  var collection = db.collection('User');
  if (await isUniqueEmail(db, user)){
    try {
      await collection.insert(user.toMap());
      return {
        "success": true,
        "message": "Registered as ${user.firstName}"
      };
    } catch (e) {
      print("Erreur lors de l'insertion : $e");
      return {
        "success": false,
        "message": "An error occurred during registration"
      };
    }
  } else {
    return {
      "success": false,
      "message": "Email already used"
    };
  }
}

// Verification si email est libre
Future<bool> isUniqueEmail(mongo.Db db, User user) async{
  var collection = db.collection('User');
  try {
    var result = await collection.findOne({'email' : user.email});
    return result == null;
  } catch (e) {
    print('Erreur lors de la récupération : $e');
  }
  return false;
}