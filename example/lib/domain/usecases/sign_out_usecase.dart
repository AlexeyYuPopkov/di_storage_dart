import 'package:example/domain/authorization_repository.dart';
import 'package:example/domain/session_info_repository.dart';

final class SignOutUsecase {
  final AuthorizationRepository authorizationRepository;
  final SessionInfoRepository sessionInfoRepository;

  const SignOutUsecase({
    required this.authorizationRepository,
    required this.sessionInfoRepository,
  });

  Future<void> execute() async {
    await authorizationRepository.signOut();
    sessionInfoRepository.dropSessionInfo();
  }
}
