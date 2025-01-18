import 'package:flutter/widgets.dart';

typedef AppContainerBuilder<T extends Object> = T Function(AppContainer container);

typedef ObjectType<T extends Object> = T;

/// AppContainer — это виджет, который предоставляет доступ к синглтонам, фабрикам и мокам.
///
/// **Порядок регистрации зависимостей:**
/// 1. **Mocks** — регистрируются первыми и имеют приоритет при разрешении зависимостей.
/// 2. **Singletons** — объекты, создающиеся один раз и доступные в течение всего времени работы приложения.
/// 3. **Singleton Builders** — создаются по запросу, но хранятся как синглтоны после первого создания.
/// 4. **Factories** — объекты, которые создаются заново каждый раз при запросе.
///
/// Конструктор принимает следующие параметры:
/// - [singletons] — карта синглтонов, создаваемых один раз и доступных во всем приложении.
/// - [singletonsBuilder] — карта билдеров синглтонов, создаваемых по запросу.
/// - [factories] — карта фабрик, которые создают новый объект при каждом запросе.
/// - [mocks] — карта моков, которые используются вместо синглтонов и фабрик при наличии.
class AppContainer extends InheritedWidget {
  final Map<Type, dynamic> _singletons;
  final Map<Type, AppContainerBuilder> _singletonsBuilder;
  final Map<Type, AppContainerBuilder> _factories;
  final Map<Type, AppContainerBuilder> _mocks;

  /// Конструктор [AppContainer], принимающий карты зарегистрированных зависимостей.
  ///
  /// - [singletons]: карта заранее созданных синглтонов.
  /// - [singletonsBuilder]: карта билдеров синглтонов, которые создаются по запросу.
  /// - [factories]: карта фабрик, создающих новые объекты при каждом вызове.
  /// - [mocks]: карта моков, которые замещают оригинальные зависимости.
  const AppContainer({
    super.key,
    required super.child,
    required Map<Type, Object> singletons,
    required Map<Type, AppContainerBuilder> singletonsBuilder,
    required Map<Type, AppContainerBuilder> factories,
    required Map<Type, AppContainerBuilder> mocks,
  })  : _singletons = singletons,
        _factories = factories,
        _mocks = mocks,
        _singletonsBuilder = singletonsBuilder;

  /// Метод для получения зависимости типа [T].
  ///
  /// Приоритет разрешения зависимости:
  /// 1. Если для типа [T] зарегистрирован мок, возвращается мок.
  /// 2. Если зарегистрирован синглтон, возвращается синглтон.
  /// 3. Если зарегистрирован билдер синглтона, вызывается билдер и результат сохраняется как синглтон.
  /// 4. Если зарегистрирована фабрика, создается новый объект каждый раз при вызове.
  ///
  /// Исключение бросается, если зависимость [T] не зарегистрирована.
  ///
  /// Если мок, билдер или фабрика возвращают `Future`, бросается ошибка, так как они должны быть синхронными.
  T get<T extends Object>() {
    if (_mocks.containsKey(T)) {
      final func = _mocks[T]!(this);
      if (func is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$this Mocks should be synchronous'),
          ErrorDescription('Mock of type $T is a Future'),
          ErrorHint('Do not use async mocks'),
        ]);
      }
      return func as T;
    }

    if (_singletons.containsKey(T)) {
      return _singletons[T];
    }

    if (_singletonsBuilder.containsKey(T)) {
      final func = _singletonsBuilder[T]!(this);
      if (func is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$this Singletons factories should be synchronous'),
          ErrorDescription('Singleton factory of type $T is a Future'),
          ErrorHint('Do not use async singletons factories'),
        ]);
      }
      _singletons[T] = func;
      return func as T;
    }

    if (_factories.containsKey(T)) {
      final func = _factories[T]!(this);
      if (func is Future) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('$this Factories should be synchronous'),
          ErrorDescription('Factory of type $T is a Future'),
          ErrorHint('Do not use async factories'),
        ]);
      }
      return func as T;
    }

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('$this Type $T is not registered'),
      ErrorHint('Add $T to singletons, singletonsFactories, factories or mocks'),
    ]);
  }

  /// Статический метод для получения зависимости типа [T] из контекста.
  ///
  /// Используется для доступа к зависимостям внутри виджетов.
  static T of<T extends Object>(BuildContext context) {
    final container = context.dependOnInheritedWidgetOfExactType<AppContainer>();
    return container!.get<T>();
  }

  /// Метод, определяющий, следует ли пересоздавать виджет при изменении зависимостей.
  ///
  /// Возвращает `true`, если изменились карты фабрик или синглтонов.
  @override
  bool updateShouldNotify(AppContainer oldWidget) =>
      !identical(_factories, oldWidget._factories) || !identical(_singletons, oldWidget._singletons);
}
