import 'package:example/presentation/common_widgets/blocking_loading_indicator.dart';
import 'package:example/presentation/router/root_router_delegate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      showSemanticsDebugger: false,
      // debugShowMaterialGrid: false,
      // checkerboardRasterCacheImages: true,
      home: BlockingLoadingIndicator(
        child: Router(
          routerDelegate: RootRouterDelegate(
            navigatorKey: GlobalKey<NavigatorState>(),
          ),
        ),
      ),
    );
  }
}
