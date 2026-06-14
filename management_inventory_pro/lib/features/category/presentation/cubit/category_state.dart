part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class CategoryLoading extends CategoryState {}
final class CategoryFailure extends CategoryState {
  final String message;

  CategoryFailure(this.message);
}
final class GetCategorySuccess extends CategoryState {
  final List<CategoryModel> categories;

  GetCategorySuccess(this.categories);
}
final class CategoryDeleteSuccess extends CategoryState {}
