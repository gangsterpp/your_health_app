import 'package:flutter/foundation.dart';
import 'package:your_health_app/domain/health_mock_data.dart';
import 'package:your_health_app/domain/health_mock_repository.dart';

class HealthController extends ChangeNotifier {
  HealthController(this._repository);
  final HealthMockRepository _repository;
  ControllerState _state = IDLE();
  ControllerState get state => _state;

  Future<void> fetchHealth() async {
    try {
      _state = Loading();
      notifyListeners();
      final data = await _repository.fetchHealth();
      _state = Loaded(data);
      notifyListeners();
    } catch (e) {
      _state = ErrorState('$e');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.cancel();
    super.dispose();
  }
}

sealed class ControllerState {
  const ControllerState();
}

class IDLE extends ControllerState {
  const IDLE();
}

class Loading extends ControllerState {
  const Loading();
}

class ErrorState extends ControllerState {
  final String message;
  const ErrorState(this.message);
}

class Loaded extends ControllerState {
  final HealthMockData data;
  const Loaded(this.data);
}
