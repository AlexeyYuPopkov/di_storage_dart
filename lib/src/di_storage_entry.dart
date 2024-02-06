import 'life_time.dart';

class DiStorageEntry<T> {
  final T Function() constructor;
  final T? instance;
  final LifeTime lifeTime;

  DiStorageEntry({
    required this.constructor,
    required this.lifeTime,
    this.instance,
  });

  DiStorageEntry<T> copyWithInstance(
    T instance,
  ) =>
      DiStorageEntry<T>(
        constructor: constructor,
        instance: instance,
        lifeTime: lifeTime,
      );
}
