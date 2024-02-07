import 'package:example/domain/do_something_repository.dart';

final class DoSomethingRepositoryImpl implements DoSomethingRepository {
  @override
  Future<void> doSomethingRepository() => Future.delayed(
        const Duration(seconds: 1),
      );
}
