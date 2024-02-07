import 'package:equatable/equatable.dart';

final class TokenInfo extends Equatable {
  final String token;

  const TokenInfo({required this.token});

  factory TokenInfo.empty() => const TokenInfo(token: '');

  bool get isValid => token.isNotEmpty;
  
  @override
  List<Object?> get props => [token];
}

