<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# DiStorage
**DiStorage** is a lightweight dependency injection library for `dart`. 
The main advantage is the small amount of code (something like 200 lines). Therefore, you can look at code and be sure how it works. You can also be sure that the program does not contain any back doors and so on. 

## Features

- Register (bind) project dependencies and retrive it.
- Unregister (unbindbind) project dependencies.
- Register (bind) scopes of dependencies.
- Unregister (unbindbind) scopes of dependencies.
- Dependency lifetime management 

## Usage

To use this plugin, add `di_storage` as a dependency in your `pubspec.yaml` file

## Examples

### Binding, using and removing dependencies
```dart
DiStorage.shared.bind<SomeInterface>(
  module: null,
  () => SomeInterfaceImpl(),
  lifeTime: const LifeTime.single(),
);

DiStorage.shared.bind<SomeUsecase>(
  module: null,
  () => SomeUsecase(
    someInterface: di.resolve(),
  ),
  lifeTime: const LifeTime.prototype(),
);
// ...
final SomeInterface someInterface = DiStorage.shared.resolve();
final SomeUsecase someUsecase = DiStorage.shared.resolve();
// ...
// When the dependencies are no longer needed, you can optionally remove them
DiStorage.shared.remove<SomeInterface>();
DiStorage.shared.remove<SomeUsecase>();
```
### Binding, using and removing scopes of dependencies
```dart
class FirstDiScope extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<SomeInterface>(
      module: this,
      () => SomeInterfaceImpl(),
      lifeTime: const LifeTime.single(),
    );

    di.bind<SomeUsecase>(
      module: null,
      () => SomeUsecase(
        someInterface: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );
  }
}

class OtherDiScope extends DiScope {
  @override
  void bind(DiStorage di) {
      di.bind<OtherInterface>(
        module: this,
        () => OtherInterfaceImpl(),
        lifeTime: const LifeTime.single(),
      );

      di.bind<OtherUsecase>(
        module: null,
        () => OtherUsecase(
          someInterface: di.resolve(),
        ),
        lifeTime: const LifeTime.prototype(),
      );
    }
  }

/// Binding
FirstDiScope().bind(DiStorage.shared);
OtherDiScope().bind(DiStorage.shared);

final SomeUsecase someUsecase = DiStorage.shared.resolve();
final OtherUsecase otherUsecase = DiStorage.shared.resolve();

// ...
// usege of `someUsecase` and `otherUsecase`
// ...

// Removing `OtherDiScope`
DiStorage.shared.removeScope<OtherDiScope>();

// ...
final isOtherUsecaseAvaileble = DiStorage.shared.canResolve<OtherUsecase>();

// `isOtherUsecaseAvaileble` = `false`

```

## Acknowledgements
Thanks to [Sergei](https://github.com/pese-git) for inspiring me to develop my own library in order to fully control its functionality.

