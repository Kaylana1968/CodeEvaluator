import 'package:code_evaluator/Model/Question.dart';
import 'package:code_evaluator/Model/Test.dart';
import 'package:code_evaluator/Model/User.dart';

class Score{
  User _user;
  Test _test;
  Map<Question, int> _mark;
  DateTime _date;

  Score(this._user, this._test, this._mark, this._date);

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Test get test => _test;

  set test(Test value) {
    _test = value;
  }

  Map<Question, int> get mark => _mark;

  set mark(Map<Question, int> value) {
    _mark = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }
}