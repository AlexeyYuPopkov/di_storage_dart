import 'package:di_storage/di_storage.dart';
import 'package:example/data/authorization_repository_impl.dart';
import 'package:example/data/session_info_repository_impl.dart';
import 'package:example/domain/authorization_repository.dart';
import 'package:example/domain/session_info_repository.dart';
import 'package:example/domain/usecases/session_info_provider_usecase.dart';
import 'package:example/domain/usecases/sign_in_usecase.dart';

final class UnauthDiScope extends DiScope {
  @override
  void bind(DiStorage di) {
    di.bind<AuthorizationRepository>(
      module: this,
      () => AuthorizationRepositoryImpl(),
      lifeTime: const LifeTime.prototype(),
    );

    di.bind<SessionInfoRepository>(
      module: this,
      () => SessionInfoRepositoryImpl(),
      lifeTime: const LifeTime.single(),
    );

    _bindUsecases(di);
  }

  void _bindUsecases(DiStorage di) {
    di.bind<SignInUsecase>(
      module: this,
      () => SignInUsecase(
        authorizationRepository: di.resolve(),
        sessionInfoRepository: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );

    di.bind<SessionInfoProviderUsecase>(
      module: this,
      () => SessionInfoProviderUsecase(
        sessionInfoRepository: di.resolve(),
      ),
      lifeTime: const LifeTime.prototype(),
    );
  }
}
