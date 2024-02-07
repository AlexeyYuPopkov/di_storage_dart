import 'package:example/domain/authorization_repository.dart';
import 'package:example/domain/model/token_info.dart';

final class AuthorizationRepositoryImpl implements AuthorizationRepository {
  @override
  Future<TokenInfo> tryAuthorize({
    required String login,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return TokenInfo(token: '$login-$password');
  }

  @override
  Future<void> signOut() => Future.delayed(
        const Duration(seconds: 1),
      );
}
