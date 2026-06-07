part of 'home_cubit.dart';

@immutable
sealed class HomeState {
  final int currentIndex;

  const HomeState(this.currentIndex);
}

final class HomeInitial extends HomeState {
  const HomeInitial():super(0);

}
final class NavigateState extends HomeState {
  const NavigateState(super.currentIndex);
}
