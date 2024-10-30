import 'package:code_evaluator/Model/Question.dart';

class Test {
  String _label;
  List<Question> _question;
  String _category;

  List<Question> get question => _question;

  Test(this._label, this._question, this._category);

  set question(List<Question> value) {
    _question = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }
}