class JsonFactoryNotFoundException implements Exception {
  final String message;

  JsonFactoryNotFoundException([this.message = '']);
}
