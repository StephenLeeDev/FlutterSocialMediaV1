/// Common empty state used for APIs with an empty response

abstract class CommonState {}

class Ready extends CommonState {}

class Loading extends CommonState {}

class Unauthorized extends CommonState {}

class Fail extends CommonState {}

class Success extends CommonState {}