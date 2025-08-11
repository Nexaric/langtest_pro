class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([ this._prefix,this._message]);

  @override
  String toString() {
    return "${_prefix ?? ''}: ${_message ?? 'An error occurred'}";
  }


}

// Custom exceptions for different error scenarios
class InternetException extends AppExceptions {
  InternetException([String? message]) : super("Check your internet connection", message??"No Network Error",);
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? message]) : super(message, "Request Time Out");
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, "Server Error");
}

class NoUserFound extends AppExceptions {
  NoUserFound([String? message]) : super(message, "Server Error");
}

