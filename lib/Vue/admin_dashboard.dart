import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/profile.dart';
import '../Model/User.dart';
import '../Controller/admin_dashboard.dart';

class AdminDashboardPage extends StatefulWidget {
  final String title;
  final mongo.Db db;

  const AdminDashboardPage({
    super.key,
    required this.title,
    required this.db,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Widget>(
          future: _scoreList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Erreur: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("Aucun score trouvé."));
            }
            return snapshot.data!;
          },
        ),
      ),
    );
  }
  Future<Widget> _scoreList() async {
    mongo.ObjectId userId = mongo.ObjectId.fromHexString('67213c1d50d27b5692000000');

    var result = await getScores(widget.db, userId as mongo.ObjectId? );
    if (result['success']) {
      print(result);
      List<Map<String, dynamic>> scores = result['data'];
      print(scores.length);
      List<Map<String, dynamic>> tests = [];

      // Récupérer tous les utilisateurs liés aux scores
      for (var score in scores) {
        List<dynamic> questionList = score['mark'];
        DateTime date = score['date'];
        print('date : $date');
        String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
        print(questionList);

        num maxPoints = 0;
        num totalUser = 0;

        // Calculer le total des points
        for (var question in questionList) {
          maxPoints += 1;
          totalUser += question['points'];
        }

        print('scoreTest ${score['test']}');
        var testResult = await getTestById(widget.db, score['test']);
        print('testresult $testResult');

        if (testResult['success']) {
          // Ajoutez les détails du test et le score à un objet
          var scoreInfo = {
            'test': testResult['data'],
            'totalUser': totalUser,
            'maxPoints': maxPoints,
            'formattedDate': formattedDate,
          };
          tests.add(scoreInfo);
        } else {
          return const Text('Aucun score disponible pour ce test.');
        }
      }

      // Vérifiez si 'tests' est vide avant de construire la ListView
      if (tests.isEmpty) {
        return const Text('Aucun test disponible.');
      }

      // Créez une liste de widgets à partir des résultats récupérés
      List<Widget> scoreWidgets = tests.map((scoreInfo) {
        var test = scoreInfo['test'];
        num totalUser = scoreInfo['totalUser'];
        num maxPoints = scoreInfo['maxPoints'];
        String formattedDate = scoreInfo['formattedDate'];

        return Card(
          margin: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(test['label']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${totalUser.toString()}/${maxPoints.toString()}'),
                Text(formattedDate),
              ],
            ),
          ),
        );
      }).toList();

      // Retournez une ListView avec tous les widgets construits
      return ListView(
        children: scoreWidgets,
      );
    } else {
      return const Text('Aucun score disponible.');
    }
  }
}
