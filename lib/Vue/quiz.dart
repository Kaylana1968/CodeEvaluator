import 'dart:async';
import 'package:code_evaluator/Vue/header.dart';
import 'package:code_evaluator/Controller/profile.dart';
import 'package:code_evaluator/Controller/question.dart';
import 'package:code_evaluator/Controller/quiz.dart';
import 'package:code_evaluator/Model/Test.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../Model/Question.dart';
import '../Model/User.dart';

class QuizPage extends StatefulWidget {
  final String title;
  final mongo.Db db;

  const QuizPage({super.key, required this.title, required this.db});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late String testLabel;
  int currentQuestionIndex = 0;
  int totalScore = 0;
  late Timer timer;
  int remainingTime = 30;
  bool testCompleted = false;
  Test? test;
  List<Question>? questions;
  Question question = Question('', [], mongo.ObjectId());
  List<Map<String, dynamic>> questionScores = [];
  List<bool> selectedChoices = [];
  User user = User("", "", "", 0, "", "", "", false);

  bool hasInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasInit) {
      final arg =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (arg != null) {
        testLabel = arg['testLabel'];
        user = arg['user'];
        fetchTestData();
      }
    }
  }

  void fetchTestData() async {
    Map<String, dynamic> result = await getTestByLabel(widget.db, testLabel);
    test = Test.fromMap(result['data']);

    if (test != null) {
      final questionResult = await getQuestionList(widget.db, test!.questions);
      questions = questionResult['data'];
      startTimer();
      loadCurrentQuestion();
    }

    hasInit = true;
  }

  void loadCurrentQuestion() async {
    if (test != null) {
      // Récupération de la question actuelle
      question = questions![currentQuestionIndex];

      // Mettre à jour selectedChoices avec la bonne longueur pour chaque question
      selectedChoices =
          List.filled(question.choices.length, false); // Réinitialisation

      setState(() {}); // Met à jour l'état de l'interface utilisateur
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          goToNextQuestion(); // skip la question sans points
        }
      });
    });
  }

  Future<void> goToNextQuestion() async {
    if (test != null && !testCompleted) {
      List<bool> correctAnswers = [];
      for (int i = 0; i < question.choices.length; i++) {
        correctAnswers.add(question.choices[i].isGood);
      }

      bool anyIncorrectSelected = false;
      for (int i = 0; i < correctAnswers.length; i++) {
        if (correctAnswers[i] != selectedChoices[i]) {
          anyIncorrectSelected = true;
          break;
        }
      }

      // 1 si bonne réponse et 0 si mauvaise
      int scoreForQuestion = !anyIncorrectSelected ? 1 : 0;

      mongo.ObjectId? currentQuestionId =
          await getQuestionIdByLabel(widget.db, question.label);

      questionScores.add({
        "question": currentQuestionId,
        "points": scoreForQuestion,
      });

      totalScore += scoreForQuestion;

      if (currentQuestionIndex < test!.questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          question = questions![currentQuestionIndex];
          remainingTime = 30;
        });
        startTimer();
        loadCurrentQuestion();
      } else {
        setState(() {
          testCompleted = true;
          saveResults();
        });
      }
    }
  }

  Future<Question> getQuestionForPrint(questionId) async {
    Map<String, dynamic> result = await getQuestion(widget.db, questionId);
    return Question.fromMap(result['data']);
  }

  void saveResults() async {
    final result = {
      "user": await getUserIdByEmail(widget.db, user.email),
      "test": await getTestIdByLabel(widget.db, test!.label),
      "mark": questionScores,
      "date": DateTime.now(),
    };
    await insertScore(widget.db, result);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (testCompleted) {
      return Scaffold(
        appBar: headerDisplay(context, widget.title, true, user),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Test complété. Score final: $totalScore"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/', arguments: user);
                },
                child: const Text("Retour à l'accueil"),
              ),
            ],
          ),
        ),
      );
    }

    if (test == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Question ${currentQuestionIndex + 1}/${test!.questions.length}"),
      ),
      body: Column(
        children: [
          Text("Temps restant: $remainingTime s"),
          Text(question.label),
          Expanded(
              // Utilisez Expanded pour que le ListView prenne l'espace disponible
              child: ListView.builder(
            itemCount: question.choices.length,
            itemBuilder: (context, index) {
              Choice choice = question.choices[index];

              return CheckboxListTile(
                title: Text(choice.choiceLabel),
                value: selectedChoices[index],
                onChanged: (bool? value) {
                  setState(() {
                    selectedChoices[index] = value!;
                  });
                },
              );
            },
          )),
          ElevatedButton(
            onPressed: goToNextQuestion,
            child: const Text("Valider"),
          ),
          Text("Score actuel: $totalScore"),
        ],
      ),
    );
  }
}
