import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/User.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(
      {super.key, required this.title, required this.db, this.user});

  final String title;
  final mongo.Db db;
  final User? user;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column());
  }
}
