import 'package:example/domain/model/token_info.dart';

abstract interface class AuthorizationRepository {
  Future<TokenInfo> tryAuthorize({
    required String login,
    required String password,
  });

  Future<void> signOut();
}
