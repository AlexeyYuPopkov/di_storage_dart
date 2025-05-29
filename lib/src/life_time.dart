/// [LifeTime] -  Describes life time of the [instance].
library;

/// If `SingleLifeTime` - the [instance] will only be created once.
///
sealed class LifeTime {
  const LifeTime();

  /// [PrototypeLifeTime] - `instance` is not maintaining, each call will create a new `instance`.
  ///
  const factory LifeTime.prototype() = PrototypeLifeTime;

  /// [SingleLifeTime] - the `instance` will only be created once.
  ///

  const factory LifeTime.single() = SingleLifeTime;
}

/// [PrototypeLifeTime] - `instance` is not maintaining, each call will create a new `instance`.
///
final class PrototypeLifeTime extends LifeTime {
  const PrototypeLifeTime();
}

/// [SingleLifeTime] - the `instance` will only be created once.
///
final class SingleLifeTime extends LifeTime {
  const SingleLifeTime();
}
