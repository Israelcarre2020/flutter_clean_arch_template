import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Uses Equatable for value equality comparison
abstract class Failure extends Equatable {

  const Failure({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server failure - occurs when API calls fail
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Cache failure - occurs when local storage operations fail
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Network failure - occurs when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure()
    : super(message: 'No internet connection', statusCode: 0);
}

/// Validation failure - occurs when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
