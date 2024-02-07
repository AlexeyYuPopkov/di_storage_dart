import 'package:example/domain/usecases/do_something_usecase.dart';
import 'package:example/domain/usecases/sign_out_usecase.dart';
import 'package:example/presentation/common_widgets/blocking_loading_indicator.dart';
import 'package:example/presentation/common_widgets/dialog_helper.dart';
import 'package:example/presentation/home_screen/bloc/home_screen_bloc.dart';
import 'package:example/presentation/home_screen/bloc/home_screen_event.dart';
import 'package:example/presentation/home_screen/bloc/home_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class HomeScreen extends StatelessWidget with DialogHelper {
  final DoSomethingUsecase doSomethingUsecase;
  final SignOutUsecase signOutUsecase;

  const HomeScreen({
    super.key,
    required this.doSomethingUsecase,
    required this.signOutUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenBloc(
        doSomethingUsecase: doSomethingUsecase,
        signOutUsecase: signOutUsecase,
      ),
      child: BlocConsumer<HomeScreenBloc, HomeScreenState>(
        listener: _listener,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => _doSomethingAction(context),
                      child: Text(
                        context.doSomethingButtonTitle,
                      ),
                    ),
                    const SizedBox(height: 48.0),
                    OutlinedButton(
                      onPressed: () => _doSignOutAction(context),
                      child: Text(
                        context.signOutButtonTitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, HomeScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;

    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showMessage(
          context,
          parameters: DialogHelperData(
            title: context.errorDialogTitle,
            message: context.unknownErrorMessage,
          ),
        );
        break;
    }
  }

  void _doSomethingAction(BuildContext context) =>
      context.read<HomeScreenBloc>().add(const HomeScreenEvent.doSomething());

  void _doSignOutAction(BuildContext context) =>
      context.read<HomeScreenBloc>().add(const HomeScreenEvent.signOut());
}

extension on BuildContext {
  String get doSomethingButtonTitle => 'Do somthing';
  String get signOutButtonTitle => 'Sign out';

  String get errorDialogTitle => 'Error';
  String get unknownErrorMessage => 'Something went wrong';
}
