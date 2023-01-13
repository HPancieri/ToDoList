class Task {
  late String _message;
  late bool _completion;

  Task({required String message, required bool completion}) {
    _message = message;
    _completion = completion;
  }

  String getMessage() => _message;
  bool getCompletion() => _completion;

  void setMessage(String message) {
    _message = message;
  }

  void setCompletion(bool completion) {
    _completion = completion;
  }
}
