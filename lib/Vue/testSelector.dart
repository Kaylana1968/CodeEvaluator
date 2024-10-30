import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:code_evaluator/Controller/category.dart';
import 'package:code_evaluator/Controller/question.dart';

class TestSelectorPage extends StatefulWidget {
  const TestSelectorPage({super.key,required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  _TestSelectorPageState createState() => _TestSelectorPageState();
}

class _TestSelectorPageState extends State<TestSelectorPage> {
  mongo.ObjectId? categoryId;
  String? label;
  Future<Map<String, dynamic>>? testResult;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupère le label depuis les arguments via ModalRoute
    final labelArg = ModalRoute.of(context)!.settings.arguments as String?;
    if (labelArg != null && label != labelArg) {
      label = labelArg;

      // Récupère l'ID de la catégorie en fonction du label
      _fetchCategoryIdAndTests(label!);
    }
  }

  Future<void> _fetchCategoryIdAndTests(String label) async {

    mongo.ObjectId? id = await CategoryController.getCategoryIdByLabel(widget.db, label);

    if (id != null) {
      setState(() {
        categoryId = id;
        testResult = getAllTestByCategory(widget.db, id); // Récupère les tests
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: testResult,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              var data = snapshot.data!;
              if (data["success"] && data["data"] != null && data["data"].isNotEmpty) {
                var tests = List<Map<String, dynamic>>.from(data["data"]);
                return ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    var test = tests[index];
                    return TestCard(testLabel: test['label']);
                  },
                );
              } else {
                return Center(child: Text(data["message"] ?? "No tests available"));
              }
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }
}

class TestCard extends StatelessWidget {
  final String testLabel;

  const TestCard({super.key, required this.testLabel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/quiz', // Page des questions
          arguments: testLabel, // Passe le label du test en argument
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(testLabel),
        ),
      ),
    );
  }
}
