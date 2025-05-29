import 'di_storage_base.dart';

/// RU: Класс [DiScope] является основой для пользовательских модулей.
///
/// EN: The [DiScope] class is the basis for custom modules.
///
/// Example of usage:
/// ```dart
/// final class SomeDiScope extends DiScope {
///   @override
///   void bind(DiStorage di) {
///     di.bind<DoSomethingUsecase>(
///       module: this,
///       () => DoSomethingUsecase(),
///       lifeTime: const LifeTime.prototype(),
///     );
///   }
/// }
///
/// SomeDiScope().bind(DiStorage.shared);
///
/// final DoSomethingUsecase doSomethingUsecase = DiStorage.shared.resolve();
/// //...
/// // use doSomethingUsecase there
/// //...
///
/// // Optionally you can remove binding of 'SomeDiScope'
/// DiStorage.shared.removeScope<SomeDiScope>();
/// ```
///
abstract class DiScope {
  const DiScope();
  void bind(DiStorage di);
}
