import 'package:code_evaluator/Model/Question.dart';

class Test {
  List<Question> _question;

  Test(this._question);

  List<Question> get question => _question;

  set question(List<Question> value) {
    _question = value;
  }
}