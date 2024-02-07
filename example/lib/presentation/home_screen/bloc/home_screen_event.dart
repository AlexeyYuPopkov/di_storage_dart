import 'package:equatable/equatable.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  const factory HomeScreenEvent.doSomething() = DoSomethingEvent;
  const factory HomeScreenEvent.signOut() = SignOutEvent;

  @override
  List<Object?> get props => const [];
}

final class DoSomethingEvent extends HomeScreenEvent {
  const DoSomethingEvent();
}

final class SignOutEvent extends HomeScreenEvent {
  const SignOutEvent();
}
