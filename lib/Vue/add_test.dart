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
  List<Question> questions = [];
  List<Category> categories = [];
  Category category = Category("");
  List<Question> existingQuestions = [];
  List<Question> categoryQuestions = [];

  void initVariables() async {
    final categoryResult = await getAllCategory(widget.db);
    categories = categoryResult['data'];
    category = categories.first;

    final questionResult = await getAllQuestion(widget.db);
    existingQuestions = questionResult['data'];

    categoryQuestions = existingQuestions
        .where((question) => question.category.label == category.label)
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
          value: question.answer.contains(index),
          onChanged: (value) => setState(() {
                value!
                    ? question.answer.add(index)
                    : question.answer.remove(index);
              })),
      Expanded(
        child: TextFormField(
          initialValue: question.choices[index],
          decoration: InputDecoration(labelText: "Choice ${index + 1}"),
          validator: (value) => value!.isEmpty ? "Enter a label" : null,
          onChanged: (value) {
            question.choices[index] = value;
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
                    question.choices.add("");
                  }),
              child: const Text("Add a choice"))
        ]);
      },
    );
  }

  Widget _buildFloatingButtons(List<Question> questions, Category category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton(
            hint: const Text("Look in existing questions"),
            items: categoryQuestions
                .asMap()
                .entries
                .map<DropdownMenuItem<int>>((entry) {
              int index = entry.key;
              Question question = entry.value;

              return DropdownMenuItem<int>(
                value: index,
                child: Text(question.label),
              );
            }).toList(),
            onChanged: (int? index) {
              if (index != null) {
                setState(() {
                  questions.add(categoryQuestions[index]);
                });
              }
            }),
        const SizedBox(width: 8.0),
        FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => setState(() {
                  questions.add(Question("", [], [], category));
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
                    DropdownButton(
                        isExpanded: true,
                        value: category,
                        items: categories.map((Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(value.label),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                              category = value!;
                              questions.clear();
                              categoryQuestions = existingQuestions
                                  .where((question) =>
                                      question.category.label == value.label)
                                  .toList();
                            })),
                    _buildQuestions(questions),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          createTest();
                        }
                      },
                      child: const Text("Create test"),
                    )
                  ],
                ))),
        floatingActionButton: _buildFloatingButtons(questions, category));
  }
}
