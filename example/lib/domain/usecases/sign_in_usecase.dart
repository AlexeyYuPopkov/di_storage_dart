import 'package:example/domain/authorization_repository.dart';
import 'package:example/domain/session_info_repository.dart';

final class SignInUsecase {
  final AuthorizationRepository authorizationRepository;
  final SessionInfoRepository sessionInfoRepository;

  const SignInUsecase({
    required this.authorizationRepository,
    required this.sessionInfoRepository,
  });

  Future<void> execute({
    required String login,
    required String password,
  }) async {
    try {
      final sessionInfo = await authorizationRepository.tryAuthorize(
        login: login,
        password: password,
      );

      if (sessionInfo.isValid) {
        sessionInfoRepository.setSessionInfo(sessionInfo);
      } else {
        sessionInfoRepository.dropSessionInfo();
      }
    } catch (e) {
      sessionInfoRepository.dropSessionInfo();
    }
  }
}
