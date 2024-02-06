abstract class LifeTime {
  const LifeTime();
  const factory LifeTime.prototype() = PrototypeLifeTime;
  const factory LifeTime.single() = SingleLifeTime;
}

class PrototypeLifeTime extends LifeTime {
  const PrototypeLifeTime();
}

class SingleLifeTime extends LifeTime {
  const SingleLifeTime();
}
