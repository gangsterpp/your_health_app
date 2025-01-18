import 'package:your_health_app/domain/health_mock_data.dart';

abstract interface class HealthMockRepository {
  void cancel();
  Future<HealthMockData> fetchHealth();
}
