import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Question.dart';
import '../Controller/add_test.dart';

const List<String> categories = ['Flutter', 'Java', 'Python', 'Javascript'];

class AddTestPage extends StatefulWidget {
  const AddTestPage({super.key, required this.title, required this.db});

  final String title;
  final mongo.Db db;

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  final formKey = GlobalKey<FormState>();
  List<Question> questions = [];
  String category = categories.first;

  List<Question> categoryQuestions = [
    Question("_label", [], ['_choices'], 'Flutter')
  ];

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
                        decoration:
                            InputDecoration(labelText: "Choice ${index + 1}"),
                        validator: (value) =>
                            value!.isEmpty ? "Enter a label" : null,
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

  Widget _buildFloatingButtons(List<Question> questions, String category) {
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
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                              category = value!;
                              questions.clear();
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