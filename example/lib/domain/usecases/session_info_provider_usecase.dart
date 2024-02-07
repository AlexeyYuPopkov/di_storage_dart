import 'package:example/domain/model/token_info.dart';
import 'package:example/domain/session_info_repository.dart';

final class SessionInfoProviderUsecase {
  final SessionInfoRepository sessionInfoRepository;

  const SessionInfoProviderUsecase({required this.sessionInfoRepository});

  Stream<TokenInfo> get sessionInfoStream =>
      sessionInfoRepository.sessionInfoStream;

  TokenInfo get currentSessionInfo => sessionInfoRepository.getToken();
}
