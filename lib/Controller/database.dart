import 'package:code_evaluator/Model/User.dart';
import 'package:code_evaluator/Model/Question.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Database {

  // Connexion a la bdd
   Future<mongo.Db> connectToDatabase() async {
    var encryptedPassword = Uri.encodeComponent('root');
    var db = await mongo.Db.create(
        'mongodb+srv://root:$encryptedPassword@cluster0.dtna3.mongodb.net/CodeEvaluator?retryWrites=true&w=majority&appName=Cluster0');
    print('Connexion à la bdd...');
    try {
      await db.open();
      print('Connexion réussie');
      print(db.databaseName);
    } catch (e) {
      print('Erreur lors de la connexion à la base de données : $e');
    }
    return db;
   }
}