import 'life_time.dart';

/// [DiStorageEntry<T>] - Internal class.
/// Box for factory method - [constructor] and instance - [instance]
///
final class DiStorageEntry<T> {
  /// [constructor] factory method for [instance]
  ///
  final T Function() constructor;

  /// [instance] - instance. Can be `null` depend of [lifeTime] option
  ///
  final T? instance;

  /// [lifeTime] -  Describes life time of the [instance].
  /// If `PrototypeLifeTime` - [instance] is not maintaining, each call will create a new [instance].
  /// If `SingleLifeTime` - the [instance] will only be created once.
  ///
  final LifeTime lifeTime;

  final void Function()? onRemove;

  const DiStorageEntry({
    required this.constructor,
    required this.lifeTime,
    this.onRemove,
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
