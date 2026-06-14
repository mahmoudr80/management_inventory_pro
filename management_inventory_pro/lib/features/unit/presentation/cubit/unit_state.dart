part of 'unit_cubit.dart';

@immutable
sealed class UnitState {}

final class UnitInitial extends UnitState {}
final class UnitLoading extends UnitState {}
final class UnitFailure extends UnitState {
  final String message;

  UnitFailure(this.message);
}
final class GetUnitSuccess extends UnitState {
final List<UnitModel>units;
GetUnitSuccess(this.units);
}
final class UnitDeleteSuccess extends UnitState {}
