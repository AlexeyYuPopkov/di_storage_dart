import 'package:di_storage/di_storage.dart';
import 'package:example/domain/do_something_repository.dart';
import 'package:example/domain/model/token_info.dart';
import 'package:example/domain/usecases/do_something_usecase.dart';
import 'package:example/domain/usecases/session_info_provider_usecase.dart';
import 'package:example/domain/usecases/sign_out_usecase.dart';
import 'package:example/presentation/common_widgets/blocking_loading_indicator.dart';
import 'package:example/presentation/di/auth_di_scope.dart';
import 'package:example/presentation/di/unauth_di_scope.dart';
import 'package:example/presentation/home_screen/home_screen.dart';
import 'package:example/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // [_installUnauthZoneDependencies] Installing dependencies for unauth zone of application
  _installUnauthZoneDependencies();

  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionInfoProviderUsecase sessionInfo = DiStorage.shared.resolve();

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      home: BlockingLoadingIndicator(
        child: StreamBuilder<TokenInfo>(
            stream: sessionInfo.sessionInfoStream.doOnData(
          (sessionInfo) {
            if (sessionInfo.isValid) {
              // [_installAuthZoneDependencies] Installing dependencies for auth zone of application
              _installAuthZoneDependencies();
            } else {
              // [_dropAuthZoneDependencies] Dropping dependencies unused in unauth zone of application
              _dropAuthZoneDependencies();
            }
          },
        ), builder: (context, snapshot) {
          final isAuthorized = snapshot.data?.isValid == true;

          // Demostration that there are not dependensies unused in unauth zone
          if (!isAuthorized) {
            assert(
              DiStorage.shared.tryResolve<DoSomethingRepository>() == null,
            );

            assert(
              DiStorage.shared.tryResolve<DoSomethingUsecase>() == null,
            );

            assert(
              DiStorage.shared.tryResolve<SignOutUsecase>() == null,
            );
          }

          return Navigator(
            key: navigatorKey,
            pages: [
              if (isAuthorized)
                MaterialPage(
                  child: HomeScreen(
                    doSomethingUsecase: DiStorage.shared.resolve(),
                    signOutUsecase: DiStorage.shared.resolve(),
                  ),
                )
              else
                MaterialPage(
                  child: SignInScreen(
                    signInUsecase: DiStorage.shared.resolve(),
                  ),
                ),
            ],
            onPopPage: (route, result) {
              if (!route.didPop(result)) {
                return false;
              }

              if (navigatorKey.currentState?.canPop() == true) {
                return true;
              }

              return false;
            },
          );
        }),
      ),
    );
  }

  Future onRoute(BuildContext context, Object action) async {}
}

/// [_installUnauthZoneDependencies] Installing dependencies for unauth zone of application
void _installUnauthZoneDependencies() {
  final di = DiStorage.shared;
  UnauthDiScope().bind(di);
}

/// [_installAuthZoneDependencies] Installing dependencies for auth zone of application
void _installAuthZoneDependencies() {
  final di = DiStorage.shared;
  AuthDiScope().bind(di);
}

/// [_dropAuthZoneDependencies] Dropping dependencies unused in unauth zone of application
void _dropAuthZoneDependencies() {
  DiStorage.shared.removeScope<AuthDiScope>();
}
