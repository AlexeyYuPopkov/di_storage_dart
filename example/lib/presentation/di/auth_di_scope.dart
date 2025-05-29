import 'package:di_storage/di_storage.dart';
import 'package:example/data/do_something_repository_impl.dart';
import 'package:example/domain/do_something_repository.dart';
import 'package:example/domain/usecases/do_something_usecase.dart';
import 'package:example/domain/usecases/sign_out_usecase.dart';

final class AuthDiScope extends DiScope {
  const AuthDiScope();
  @override
  void bind(DiStorage di) {
    di.bind<DoSomethingRepository>(
      module: this,
      () => DoSomethingRepositoryImpl(),
      lifeTime: const LifeTime.prototype(),
    );

    _bindUsecases(di);
  }

  void _bindUsecases(DiStorage di) {
    di.bind<DoSomethingUsecase>(
      module: this,
      () => DoSomethingUsecase(
        repository: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
      onRemove: () {
        // ignore: avoid_print
        print('Do something after removing');
      },
    );

    di.bind<SignOutUsecase>(
      module: this,
      () => SignOutUsecase(
        authorizationRepository: di.resolve(),
        sessionInfoRepository: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );
  }
}
