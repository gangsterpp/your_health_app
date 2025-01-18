import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:your_health_app/controllers/health_controller.dart';
import 'package:your_health_app/core/di/app_container.dart';
import 'package:your_health_app/core/network/dio_bootstrap.dart';
import 'package:your_health_app/domain/health_mock_repository.dart';
import 'package:your_health_app/features/home/home.dart';
import 'package:your_health_app/repository/health_mock_repository_impl.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('ru_RU');
    final dio = bootstrapDio();
    HealthMockRepository;
    runApp(AppContainer(
      singletons: {
        Dio: dio,
      },
      singletonsBuilder: {},
      factories: {
        CancelToken: (_) {
          return CancelToken();
        },
        HealthMockRepository: (c) {
          return HealthMockRepositoryImpl(
            dio: c.get<Dio>(),
            cancelToken: c.get<CancelToken>(),
          );
        },
        HealthController: (c) => HealthController(c.get<HealthMockRepository>()),
      },
      mocks: {},
      child: MainApp(),
    ));
  }, (e, s) {
    log('ERROR', error: e, stackTrace: s);
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
