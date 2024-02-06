import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_screen_data.dart';
import 'sign_in_screen_event.dart';
import 'sign_in_screen_state.dart';

final class SignInScreenBloc
    extends Bloc<SignInScreenEvent, SignInScreenState> {
  SignInScreenData get data => state.data;

  SignInScreenBloc()
      : super(
          SignInScreenState.common(
            data: SignInScreenData.initial(),
          ),
        ) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<TrySignInEvent>(_onInitialEvent);
  }

  void _onInitialEvent(
    TrySignInEvent event,
    Emitter<SignInScreenState> emit,
  ) async {
    try {
      emit(SignInScreenState.loading(data: data));

      await Future.delayed(const Duration(seconds: 2));

      emit(
        SignInScreenState.common(data: data),
      );
    } catch (e) {
      emit(SignInScreenState.error(e: e, data: data));
    }
  }
}
