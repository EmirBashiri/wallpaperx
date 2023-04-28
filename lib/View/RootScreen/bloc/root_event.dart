part of 'root_bloc.dart';

@immutable
abstract class RootEvent {}

class RootStart extends RootEvent {
  final int currentIndex;

  RootStart(this.currentIndex);
}
