import 'package:dio/dio.dart';
import 'package:gist/core/config/app_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Dio client configuration
/// Provides a configured Dio instance for HTTP requests
class DioClient {

  DioClient(this._config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.apiBaseUrl,
        connectTimeout: _config.apiTimeout,
        receiveTimeout: _config.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logger interceptor only for non-production environments
    if (_config.enableLogger) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }
  }
  final AppConfig _config;
  late final Dio _dio;

  Dio get dio => _dio;
}
