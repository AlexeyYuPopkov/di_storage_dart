import 'package:di_storage/di_storage.dart';
import 'package:test/test.dart';

void main() {
  group('Life time', () {
    test(
      'Life time test',
      () {
        DiStorage.shared.removeAll();

        DiStorage.shared.bind<Usecase1>(
          module: null,
          () => Usecase1(),
          lifeTime: const LifeTime.prototype(),
        );

        DiStorage.shared.bind<Usecase2>(
          module: null,
          () => Usecase2(),
          lifeTime: const LifeTime.single(),
        );

        final Usecase1 usecase1_1 = DiStorage.shared.resolve();
        final Usecase1 usecase1_2 = DiStorage.shared.resolve();

        final Usecase2 usecase2_1 = DiStorage.shared.resolve();
        final Usecase2 usecase2_2 = DiStorage.shared.resolve();

        final isSameInstanceOfUsecase1 = identical(usecase1_1, usecase1_2);

        expect(isSameInstanceOfUsecase1, false);

        final isSameInstanceOfUsecase2 = identical(usecase2_1, usecase2_2);

        expect(isSameInstanceOfUsecase2, true);
      },
    );
  });
  group(
    'Without scopes',
    () {
      test(
        'Binding',
        () {
          DiStorage.shared.removeAll();
          expect(DiStorage.shared.tryResolve<Interface1>(), null);
          expect(DiStorage.shared.tryResolve<Usecase1>(), null);

          DiStorage.shared.bind<Interface1>(
            module: null,
            () => Interface1Impl(),
            lifeTime: const LifeTime.prototype(),
          );

          DiStorage.shared.bind<Usecase1>(
            module: null,
            () => Usecase1(),
            lifeTime: const LifeTime.prototype(),
          );

          final Interface1 result1 = DiStorage.shared.resolve();
          final Usecase1 result2 = DiStorage.shared.resolve();

          expect(result1, isA<Interface1>());
          expect(result1, isA<Interface1Impl>());
          expect(result2, isA<Usecase1>());
        },
      );

      test(
        'Removing',
        () {
          expect(DiStorage.shared.canResolve<Interface1>(), true);
          expect(DiStorage.shared.canResolve<Usecase1>(), true);

          DiStorage.shared.remove<Interface1>();
          DiStorage.shared.remove<Usecase1>();

          expect(DiStorage.shared.canResolve<Interface1>(), false);
          expect(DiStorage.shared.canResolve<Usecase1>(), false);
        },
      );
    },
  );
}

abstract class Interface1 {}

class Interface1Impl implements Interface1 {}

class Usecase1 {}

class Usecase2 {}
