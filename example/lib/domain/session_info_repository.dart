import 'package:example/domain/model/token_info.dart';

abstract interface class SessionInfoRepository {
  Stream<TokenInfo> get sessionInfoStream;
  TokenInfo getToken();
  void setSessionInfo(TokenInfo token);
  void dropSessionInfo();
}
