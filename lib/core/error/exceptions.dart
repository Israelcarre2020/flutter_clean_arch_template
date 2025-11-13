/// Custom exceptions for the application
class ServerException implements Exception {

  ServerException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CacheException implements Exception {

  CacheException({required this.message});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {

  NetworkException({this.message = 'No internet connection'});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
