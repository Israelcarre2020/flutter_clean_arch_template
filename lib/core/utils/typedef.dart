import 'package:dartz/dartz.dart';
import 'package:gist/core/error/failures.dart';

/// Type definition for functions that return Either with Failure or success type
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Type definition for synchronous Either results
typedef ResultVoid = Either<Failure, void>;
