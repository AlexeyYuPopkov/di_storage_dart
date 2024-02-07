import 'package:example/domain/model/token_info.dart';
import 'package:example/domain/session_info_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SessionInfoRepositoryImpl implements SessionInfoRepository {
  static const String _sessionInfoKey = 'SessionInfoRepository.SessionInfoKey';

  final _sessionInfoStream = BehaviorSubject.seeded(TokenInfo.empty());

  SessionInfoRepositoryImpl() {
    _readToken();
  }

  @override
  void dropSessionInfo() {
    // Warning: do not use Shared preferences as sesetive data storage
    SharedPreferences.getInstance()
        .then(
          (storage) => storage.remove(_sessionInfoKey),
        )
        .then(
          (_) => _readToken(),
        );
  }

  @override
  TokenInfo getToken() => _sessionInfoStream.value;

  @override
  Future<void> setSessionInfo(TokenInfo tokenInfo) async {
    // Warning: do not use Shared preferences as sesetive data storage
    final storage = await SharedPreferences.getInstance();

    storage.setString(_sessionInfoKey, tokenInfo.token).then(
          (_) => _readToken(),
        );
  }

  @override
  Stream<TokenInfo> get sessionInfoStream =>
      _sessionInfoStream.distinct().asBroadcastStream();

  Future<void> _readToken() async {
    // Warning: do not use Shared preferences as sesetive data storage
    SharedPreferences.getInstance().then(
      (storage) {
        final str = storage.getString(_sessionInfoKey);

        final token = str == null || str.isEmpty
            ? TokenInfo.empty()
            : TokenInfo(token: str);

        _sessionInfoStream.add(token);
      },
    );
  }
}
