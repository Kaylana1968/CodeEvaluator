class User {
  String _lastName;
  String _firstName;
  String _password;
  int _age;
  String _email;
  String _address;
  String _motivation;
  bool _admin;

  User(this._lastName, this._firstName, this._password, this._age, this._email,
      this._address, this._motivation, this._admin);

  User.fromMap(Map<String, dynamic> map)
      : _lastName = map['lastName'],
        _firstName = map['firstName'],
        _password = map['password'],
        _age = map['age'],
        _email = map['email'],
        _address = map['address'],
        _motivation = map['motivation'],
        _admin = map['isAdmin'];

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get motivation => _motivation;

  set motivation(String value) {
    _motivation = value;
  }

  bool get admin => _admin;

  set admin(bool value) {
    _admin = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'password': password,
      'age': age,
      'email': email,
      'address': address,
      'motivation': motivation,
      'isAdmin': admin,
    };
  }
}
