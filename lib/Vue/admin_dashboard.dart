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
  User? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as User?;

    if (args == null || user?.admin == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      user = args;
    }
  }

  Future<Widget> _scoreList() async {
    var result = await getScores(widget.db);
    if (result['success']) {
      List<Map<String, dynamic>> scores = result['data'];
      List<Map<String, dynamic>> tests = [];

      // Récupérer tous les utilisateurs liés aux scores
      for (var score in scores) {
        List<dynamic> questionList = score['mark'];
        DateTime date = score['date'];
        String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);

        num maxPoints = 0;
        num totalUser = 0;

        // Calculer le total des points
        for (var question in questionList) {
          maxPoints += 1;
          totalUser += question['points'];
        }

        var testResult = await getTestById(widget.db, score['test']);

        if (testResult['success']) {
          // Ajoutez les détails du test et le score à un objet
          var scoreInfo = {
            '_id': score['test'],
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
              )),
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

  Future<Widget> _testList() async {
    var result = await getTest(widget.db);
    if (result['success']) {
      List<Map<String, dynamic>> tests = result['data'];

      // Retournez une ListView avec tous les widgets construits
      return ListView.builder(
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];

            return Card(
                margin: const EdgeInsets.all(10.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(test['label']),
                          IconButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, "/edit-test",
                                  arguments: {'user': user!, 'testId': test['_id']}),
                              icon: const Icon(Icons.edit)),
                        ])));
          });
    } else {
      return const Text('Aucun score disponible.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/add-test", arguments: user!),
              child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add), Text("Add a test")])),
          const Text("All tests list:"),
          Expanded(
            // Utiliser Expanded pour le ListView
            child: FutureBuilder<Widget>(
              future: _testList(),
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
          const Text("All scores list:"),
          Expanded(
            // Utiliser Expanded pour le ListView
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
        ],
      ),
    );
  }
}
