enum HttpRequestTypes {
  POST(),
  GET(),
  PUT(),
  DELETE();

  @override
  String toString() {
    switch (this) {
      case POST:
        return "POST";
      case GET:
        return "GET";
      case PUT:
        return "PUT";
      case DELETE:
        return "DELETE";
    }
  }
}
