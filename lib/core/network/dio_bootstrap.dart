import 'package:dio/dio.dart';

Dio bootstrapDio() {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://158.160.30.46:8080',
    sendTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    connectTimeout: Duration(seconds: 30),
  ));
  return dio;
}
