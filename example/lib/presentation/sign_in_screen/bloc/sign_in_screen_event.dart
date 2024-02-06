import 'package:equatable/equatable.dart';

sealed class SignInScreenEvent extends Equatable {
  const SignInScreenEvent();

  const factory SignInScreenEvent.trySignIn({
    required String login,
    required String password,
  }) = TrySignInEvent;

  @override
  List<Object?> get props => const [];
}

final class TrySignInEvent extends SignInScreenEvent {
  final String login;
  final String password;

  const TrySignInEvent({
    required this.login,
    required this.password,
  });
}
