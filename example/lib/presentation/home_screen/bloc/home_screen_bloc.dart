import 'package:example/domain/usecases/do_something_usecase.dart';
import 'package:example/domain/usecases/sign_out_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen_data.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

final class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenData get data => state.data;

  final DoSomethingUsecase doSomethingUsecase;
  final SignOutUsecase signOutUsecase;

  HomeScreenBloc({
    required this.doSomethingUsecase,
    required this.signOutUsecase,
  }) : super(
          HomeScreenState.common(
            data: HomeScreenData.initial(),
          ),
        ) {
    _setupHandlers();

    add(const HomeScreenEvent.doSomething());
  }

  void _setupHandlers() {
    on<DoSomethingEvent>(_onDoSomethingEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  void _onDoSomethingEvent(
    DoSomethingEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      emit(HomeScreenState.loading(data: data));

      await doSomethingUsecase.execute();

      emit(HomeScreenState.common(data: data));
    } catch (e) {
      emit(HomeScreenState.error(e: e, data: data));
    }
  }

  void _onSignOutEvent(
    SignOutEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      emit(HomeScreenState.loading(data: data));

      await signOutUsecase.execute();

      emit(HomeScreenState.common(data: data));
    } catch (e) {
      emit(HomeScreenState.error(e: e, data: data));
    }
  }
}
