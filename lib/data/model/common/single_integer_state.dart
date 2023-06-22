/// Common single integer state used for APIs with an empty response

abstract class SingleIntegerState {}

class Ready extends SingleIntegerState {}

class Loading extends SingleIntegerState {}

class Unauthorized extends SingleIntegerState {}

class Fail extends SingleIntegerState {}

class Success extends SingleIntegerState {
  final int _value;
  Success(this._value);

  int get getValue => _value;
}