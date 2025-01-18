import 'package:dio/dio.dart';
import 'package:your_health_app/domain/health_mock_data.dart';
import 'package:your_health_app/domain/health_mock_repository.dart';

class HealthMockRepositoryImpl implements HealthMockRepository {
  final CancelToken _cancelToken;
  final Dio _dio;

  const HealthMockRepositoryImpl({required CancelToken cancelToken, required Dio dio})
      : _cancelToken = cancelToken,
        _dio = dio;

  @override
  void cancel() {
    _cancelToken.cancel();
  }

  @override
  Future<HealthMockData> fetchHealth() async {
    final response = await _dio.get('/health_mock', cancelToken: _cancelToken);
    return HealthMockData.fromJson(response.data);
  }
}
