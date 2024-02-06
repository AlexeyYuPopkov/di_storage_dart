import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';

class BlockingLoadingIndicator extends InheritedWidget {
  final streem = BehaviorSubject<bool>.seeded(false);

  bool get isLoading => streem.value;

  set isLoading(bool newValue) => streem.add(newValue);

  BlockingLoadingIndicator({
    super.key,
    required Widget child,
  }) : super(
          child: BlockingLoadingIndicatorWidget(
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static BlockingLoadingIndicator? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BlockingLoadingIndicator>();
  }

  static BlockingLoadingIndicator of(BuildContext context) {
    final BlockingLoadingIndicator? result = maybeOf(context);
    assert(result != null, 'No BlockingLoadingIndicator found in context');
    return result!;
  }
}

class BlockingLoadingIndicatorWidget extends StatelessWidget {
  final Widget child;

  const BlockingLoadingIndicatorWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          StreamBuilder<bool>(
            initialData: false,
            stream: BlockingLoadingIndicator.of(context).streem.distinct(),
            builder: (context, snapshot) {
              final isLoading = snapshot.data ??
                  BlockingLoadingIndicator.of(context).isLoading;

              return Visibility(
                visible: isLoading,
                child: const AbsorbPointer(
                  child: Center(
                    child: RepaintBoundary(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
}
