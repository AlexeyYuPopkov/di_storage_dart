import 'package:equatable/equatable.dart';

import 'sign_in_screen_data.dart';

sealed class SignInScreenState extends Equatable {
  final SignInScreenData data;

  const SignInScreenState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory SignInScreenState.common({
    required SignInScreenData data,
  }) = CommonState;

  const factory SignInScreenState.loading({
    required SignInScreenData data,
  }) = LoadingState;

  const factory SignInScreenState.error({
    required SignInScreenData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends SignInScreenState {
  const CommonState({required super.data});
}

final class LoadingState extends SignInScreenState {
  const LoadingState({required super.data});
}

final class ErrorState extends SignInScreenState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}

final class ShouldLoginState extends SignInScreenState {
  const ShouldLoginState({required super.data});
}
