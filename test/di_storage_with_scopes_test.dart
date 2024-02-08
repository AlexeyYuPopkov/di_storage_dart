import 'package:di_storage/di_storage.dart';
import 'package:test/test.dart';

void main() {
  // Sequence of tests is significant
  group(
    'With scopes',
    () {
      test(
        'Bind `FirstDiScope`',
        () {
          final di = DiStorage.shared;
          di.removeAll();
          FirstDiScope().bind(di);

          _checkIfFirstDiScopeBinded();
        },
      );

      test(
        'Bind `SecondDiScope`',
        () {
          final di = DiStorage.shared;

          SecondDiScope().bind(di);

          _checkIfSecondDiScopeBinded();
          _checkIfFirstDiScopeBinded();
        },
      );

      test(
        'Remove `SecondDiScope`',
        () {
          DiStorage.shared.removeScope<SecondDiScope>();

          _checkIfSecondDiScopeNotBinded();
          _checkIfFirstDiScopeBinded();
        },
      );

      test(
        'Remove `FirstDiScope`',
        () {
          DiStorage.shared.removeScope<FirstDiScope>();

          _checkIfSecondDiScopeNotBinded();
          _checkIfFirstDiScopeNotBinded();
        },
      );
    },
  );
}

void _checkIfFirstDiScopeBinded() {
  final di = DiStorage.shared;
  final Interface1 interface1 = di.resolve();
  final Usecase1 usecase1 = di.resolve();
  final Usecase2 usecase2 = di.resolve();

  expect(interface1, isA<Interface1>());
  expect(interface1, isA<Interface1Impl>());

  expect(usecase1, isA<Usecase1>());
  expect(usecase2, isA<Usecase2>());

  final isSameInstanceOfInterface1 = identical(
    usecase1.interface1,
    usecase2.interface1,
  );

  expect(isSameInstanceOfInterface1, true);
}

void _checkIfSecondDiScopeBinded() {
  final di = DiStorage.shared;
  final Interface2 interface2 = di.resolve();
  final Usecase3 usecase3 = di.resolve();

  expect(interface2, isA<Interface2>());
  expect(interface2, isA<Interface2Impl>());

  expect(usecase3, isA<Usecase3>());
}

void _checkIfSecondDiScopeNotBinded() {
  final di = DiStorage.shared;
  final hasInterface2 = di.canResolve<Interface2>();
  final usecase3 = di.tryResolve<Usecase3>();

  expect(hasInterface2, false);
  expect(usecase3, null);
}

void _checkIfFirstDiScopeNotBinded() {
  final di = DiStorage.shared;
  final interface1 = di.tryResolve<Interface1>();
  final hasUsecase1 = di.canResolve<Usecase1>();
  final hasUsecase2 = di.canResolve<Usecase2>();

  expect(interface1, null);

  expect(hasUsecase1, false);
  expect(hasUsecase2, false);
}

abstract class Interface1 {}

class Interface1Impl implements Interface1 {}

class Usecase1 {
  final Interface1 interface1;

  Usecase1({required this.interface1});
}

class Usecase2 {
  final Interface1 interface1;
  final Usecase1 usecase1;

  Usecase2({
    required this.interface1,
    required this.usecase1,
  });
}

class FirstDiScope extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<Interface1>(
      module: this,
      () => Interface1Impl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<Usecase1>(
      module: this,
      () => Usecase1(
        interface1: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );

    di.bind<Usecase2>(
      module: this,
      () => Usecase2(
        interface1: di.resolve(),
        usecase1: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );
  }
}

abstract class Interface2 {}

class Interface2Impl implements Interface2 {}

class Usecase3 {
  final Interface2 interface2;

  Usecase3({required this.interface2});
}

class SecondDiScope extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<Interface2>(
      module: this,
      () => Interface2Impl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<Usecase3>(
      module: this,
      () => Usecase3(
        interface2: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );
  }
}
