import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Question.dart';
import '../Model/Category.dart';
import '../Model/User.dart';
import '../Controller/add_test.dart';
import '../Controller/question.dart';

class AddTestPage extends StatefulWidget {
  const AddTestPage(
      {super.key, required this.title, required this.db, this.user});

  final String title;
  final mongo.Db db;
  final User? user;

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  final formKey = GlobalKey<FormState>();
  String testLabel = "";
  List<Question> questions = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic> category = {};
  List<Question> existingQuestions = [];
  List<Question> categoryQuestions = [];

  void initVariables() async {
    final categoryResult = await getAllCategory(widget.db);
    categories = categoryResult['data'];
    category = categories.first;

    final questionResult = await getAllQuestion(widget.db);
    existingQuestions = questionResult['data'];

    categoryQuestions = existingQuestions
        .where((question) => question.category == category['_id'])
        .toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  Widget _buildChoiceRow(Question question, int index) {
    return Row(children: [
      Checkbox(
          value: question.choices[index].isGood,
          onChanged: (value) => setState(() {
                question.choices[index].isGood = value!;
              })),
      Expanded(
        child: TextFormField(
          initialValue: question.choices[index].choiceLabel,
          decoration: InputDecoration(labelText: "Choice ${index + 1}"),
          validator: (value) => value!.isEmpty ? "Enter a choice" : null,
          onChanged: (value) {
            question.choices[index].choiceLabel = value;
          },
        ),
      ),
      IconButton(
          onPressed: () => setState(() {
                question.choices.removeAt(index);
              }),
          icon: const Icon(Icons.close))
    ]);
  }

  Widget _buildQuestions(List<Question> questions) {
    return ListView.builder(
      itemCount: questions.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Question question = questions[index];

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                initialValue: question.label,
                decoration: const InputDecoration(labelText: "label"),
                validator: (value) => value!.isEmpty ? "Enter a label" : null,
                onChanged: (value) => question.label = value,
              )),
              IconButton(
                  onPressed: () => setState(() {
                        questions.removeAt(index);
                      }),
                  icon: const Icon(Icons.close))
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: question.choices.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildChoiceRow(question, index);
                },
              )),
          const SizedBox(height: 8.0),
          ElevatedButton(
              onPressed: () => setState(() {
                    question.choices.add(Choice("", false));
                  }),
              child: const Text("Add a choice"))
        ]);
      },
    );
  }

  Widget _buildFloatingButtons(
      List<Question> questions, Map<String, dynamic> category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton(
            hint: const Text("Look in existing questions"),
            items: categoryQuestions.map((Question question) {
              return DropdownMenuItem<Question>(
                value: question,
                child: Text(question.label),
              );
            }).toList(),
            onChanged: (Question? question) {
              if (question != null) {
                setState(() {
                  questions.add(Question.clone(question));
                });
              }
            }),
        const SizedBox(width: 8.0),
        FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => setState(() {
                  questions.add(Question("", [], category['_id']));
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
            margin: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: "Test label"),
                        validator: (value) =>
                            value!.isEmpty ? "Enter a label" : null,
                        onChanged: (value) => setState(() {
                              testLabel = value;
                            })),
                    DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      value: category,
                      items: categories.map((Map<String, dynamic> value) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: value,
                          child: Text(value['label']),
                        );
                      }).toList(),
                      onChanged: (Map<String, dynamic>? newValue) {
                        if (newValue != null) {
                          setState(() {
                            category = newValue;
                            questions.clear();
                            categoryQuestions = existingQuestions
                                .where((question) =>
                                    question.category == newValue['_id'])
                                .toList();
                          });
                        }
                      },
                    ),
                    _buildQuestions(questions),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Map<String, dynamic> result = await createTest(
                              widget.db, testLabel, questions, category);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'])),
                          );
                        }
                      },
                      child: const Text("Create test"),
                    )
                  ],
                ))),
        floatingActionButton: _buildFloatingButtons(questions, category));
  }
}
