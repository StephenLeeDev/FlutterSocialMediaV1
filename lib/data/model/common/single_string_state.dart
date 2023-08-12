/// Common single string state used for API response

abstract class SingleStringState {}

class Ready extends SingleStringState {}

class Loading extends SingleStringState {}

class Unauthorized extends SingleStringState {}

class Fail extends SingleStringState {}

class Success extends SingleStringState {
  final String _value;
  Success(this._value);

  String get getValue => _value;
}