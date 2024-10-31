import 'dart:ffi';

import 'package:code_evaluator/Model/Score.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';
import '../Controller/profile.dart';
import 'package:intl/intl.dart';
import 'package:code_evaluator/Controller/profile.dart';

const List<String> motivations = [
  "Poursuite d'études",
  "Reconversion professionnelle",
  "Réorientation"
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController addressController = TextEditingController();
  String motivationValue = motivations.first;

  late Map<String, dynamic> result;
  late List<Map<String, dynamic>> scores;

  User user = User("monNom", "monPrenom", "password", 4, "monMail@gmail.com", "maMaison", "maMotivation", false);

  Widget modifyAddress() {
    Map<String, dynamic> result;
    return Column(children: [
      TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          labelText: "Modify Address",
        ),
        validator: (value) => value!.isEmpty ? 'Enter your last name' : null,
      ),
      ElevatedButton(
          child: const Text('Modify'),
          onPressed: () async {
            result = await updateAddress(widget.db, user.email, addressController.text);
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${result['message']}")),
          );
         }
      )
    ]);
  }

  Future<Widget> _scoreList() async {
    mongo.ObjectId userId = mongo.ObjectId.fromHexString('67213c1d50d27b5692000000');

    var result = await getScore(userId, widget.db);
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

  Widget modifyMotivation() {
    Map<String, dynamic> result;
    return Column(children: [
      DropdownButton(
        isExpanded: true,
        value: motivationValue,
        items: motivations.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => setState(() {
          motivationValue = value!;
        }),
      ),
      ElevatedButton(
          child: const Text('Modify'),
          onPressed: () async {
            result = await updateMotivations(widget.db, user.email, motivationValue);
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${result['message']}")),
            );
          }
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 50,
                  ),
                  Text("${user.firstName} ${user.lastName}"),
                  Text(user.age.toString()),
                  Text(user.address),
                  Text(user.email),
                  Text(user.motivation),
                ],
              ),
            ),
          ),
          Form(child: modifyAddress()),
          Form(child: modifyMotivation()),
          Expanded(
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
