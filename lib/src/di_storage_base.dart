import 'di_scope.dart';
import 'di_storage_entry.dart';
import 'life_time.dart';
export 'life_time.dart';

/// RU: [DiStorage] - класс для кеширования обьектов [T]
///
/// EN: [DiStorage] - class for caching objects [T]
///
class DiStorage {
  static DiStorage? _instance;

  DiStorage._();

  static DiStorage get shared => _instance ??= DiStorage._();

  late final _constructorsMap = <String, DiStorageEntry>{};

  late final _scopesMap = <String, Set<String>>{};

  /// RU: [bind] - привязка зависимости [T] к фабричному методу
  ///
  /// EN: [bind] - binding [T] dependency to a factory method
  ///
  /// Example without scope:
  ///
  /// DiStorage.shared.bind<DoSomethingRepository>(
  ///   module: null,
  ///   () => DoSomethingRepositoryImpl(),
  ///   lifeTime: const LifeTime.single(),
  /// );
  ///
  /// Example with scope:
  ///
  /// final class SomeDiScope extends DiScope {
  ///   @override
  ///   void bind(DiStorage di) {
  ///     di.bind<DoSomethingRepository>(
  ///       module: this,
  ///       () => DoSomethingRepositoryImpl(),
  ///       lifeTime: const LifeTime.single(),
  ///     );
  ///   }
  /// }
  ///
  /// SomeDiScope().bind(DiStorage.shared);
  ///
  void bind<T>(
    T Function() constructor, {
    required DiScope? module,
    LifeTime? lifeTime,
  }) {
    final name = T.toString();
    _constructorsMap[name] = DiStorageEntry(
      constructor: constructor,
      lifeTime: lifeTime ?? const LifeTime.prototype(),
    );

    final scopeName = module?.runtimeType.toString();

    if (scopeName != null && scopeName.isNotEmpty) {
      var names = _scopesMap[scopeName];

      if (names == null) {
        _scopesMap[scopeName] = {name};
      } else {
        names.add(name);
        _scopesMap[scopeName] = names;
      }
    }
  }

  /// RU: [canResolve] - привязана ли зависимость с типом <T>
  ///
  /// EN: [resolve] - is binded the dependency with type <T>
  ///
  /// Example:
  ///
  /// final hasDependency = DiStorage.shared.canResolve<DoSomethingRepository>();
  ///
  bool canResolve<T>() {
    final name = T.toString();
    return _constructorsMap[name] != null;
  }

  /// RU: [resolve] - разрешение (получение) зависимости с типом <T>
  ///
  /// EN: [resolve] - resolve the dependency with type <T>
  ///
  /// Example:
  ///
  /// final DoSomethingRepository result = DiStorage.shared.resolve();
  ///
  T resolve<T>() {
    final name = T.toString();

    final box = _constructorsMap[name];

    if (box == null) {
      throw Exception('DiStorage: Forgot bind instance: $name');
    }

    return _resolve(box, name);
  }

  /// RU: [tryResolve] - разрешение (получение) зависимости с типом <T>
  /// или null, если отсутствует
  ///
  /// EN: [tryResolve] - resolve the dependency with type <T> or null if absent
  ///
  /// Example:
  ///
  /// final DoSomethingRepository? result = DiStorage.shared.tryResolve<DoSomethingRepository>();
  ///
  T? tryResolve<T>() {
    final name = T.toString();

    final box = _constructorsMap[name];

    if (box == null) {
      return null;
    }

    return _resolve(box, name);
  }

  /// RU: [remove] - удаление зависимости <T>
  ///
  /// EN: [remove] - remove the dependency with type <T>
  ///
  /// Example:
  ///
  /// DiStorage.shared.remove<DoSomethingRepository>();
  ///
  void remove<T>() => _constructorsMap.remove(T.toString());

  /// RU: [remove] - удаление модуля <T>
  ///
  /// EN: [remove] - remove the dependency with type <T>
  ///
  /// Example:
  ///
  /// DiStorage.shared.removeScope<SomeDiScope>();
  ///
  void removeScope<S extends DiScope>() {
    final scopeName = S.toString();

    final names = _scopesMap[scopeName];

    if (names != null && names.isNotEmpty) {
      for (final instanceName in names) {
        _constructorsMap.remove(instanceName);
      }
    }
  }

  /// RU: [removeAll] - удаление всех записей
  ///
  /// EN: [removeAll] - remove all entries
  ///
  /// Example:
  ///
  /// DiStorage.shared.removeAll();
  ///
  void removeAll() {
    _constructorsMap.clear();
    _scopesMap.clear();
  }
}

// Private
extension on DiStorage {
  T _resolve<T>(DiStorageEntry box, String name) {
    final instance = box.instance;

    if (instance != null && instance is T) {
      return instance;
    } else {
      final lifeTime = box.lifeTime;

      if (lifeTime is PrototypeLifeTime) {
        return box.constructor();
      } else if (lifeTime is SingleLifeTime) {
        final instance = box.instance;

        if (instance == null) {
          final instance = box.constructor();
          final newBox = box.copyWithInstance(instance);
          _constructorsMap[name] = newBox;
          return newBox.instance!;
        } else {
          return instance;
        }
      } else {
        throw UnimplementedError('DiStorage: Unimplemented object life time');
      }
    }
  }
}
