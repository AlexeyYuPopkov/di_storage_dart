import 'package:di_storage/di_storage.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('Single instance binding', () {
      expect(DiStorage.shared.tryResolve<Interface1>(), null);

      DiStorage.shared.bind<Interface1>(
        module: null,
        () => Interface1Impl(),
        lifeTime: const LifeTime.prototype(),
      );

      final Interface1 result = DiStorage.shared.resolve();

      expect(result, isA<Interface1>());
      expect(result, isA<Interface1Impl>());
    });
  });
}

abstract class Interface1 {}

class Interface1Impl implements Interface1 {}
