import 'package:example/domain/do_something_repository.dart';

final class DoSomethingUsecase {
  final DoSomethingRepository repository;

  const DoSomethingUsecase({required this.repository});

  Future<void> execute() => repository.doSomethingRepository();
}
