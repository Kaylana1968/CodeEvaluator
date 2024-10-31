import 'package:code_evaluator/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Controller/header.dart';
import '../Model/Category.dart';
import 'package:code_evaluator/Controller/category.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Future<Map<String, dynamic>>? result;
  late User user = User("", "", "", 0, "", "", "", false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupère le user depuis les arguments via ModalRoute
    final userArg = ModalRoute.of(context)!.settings.arguments as User?;
    if (userArg != null) {
      user = userArg;
    }
    result = CategoryController.getAllCategory(widget.db);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerDisplay(context, widget.title, true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Choose your category for the test"),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    var data = snapshot.data!;
                    if (data["success"] && data["data"] != null && data["data"].isNotEmpty) {
                      var categories = List<Map<String, dynamic>>.from(data["data"]);
                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return displayCard(Category.fromJson(categories[index]));
                        },
                      );
                    } else {
                      return Center(child: Text(data["message"] ?? "No data available"));
                    }
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayCard(Category dbData) {
    String label = dbData.label;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/test/selector', arguments: {'label' :label, 'user' : user});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(dbData.label),
            ],
          ),
        ),
      ),
    );
  }
}
