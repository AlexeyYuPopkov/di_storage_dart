import 'package:example/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';

final class RootRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late List<Page> pages = [
    MaterialPage(
      child: SignInScreen(
        onRoute: onRoute,
      ),
    ),
  ];

  RootRouterDelegate({
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        updateState();
        if (!route.didPop(result)) {
          return false;
        }

        if (context.navigator.canPop()) {
          return true;
        }

        return false;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}

  void updateState() {
    notifyListeners();
  }

  Future onRoute(BuildContext context, Object action) async {}
}

extension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
}
