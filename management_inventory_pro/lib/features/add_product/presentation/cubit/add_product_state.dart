part of 'add_product_cubit.dart';

@immutable
sealed class AddProductState {}

final class AddProductInitial extends AddProductState {}
final class AddProductLoading extends AddProductState {}
final class AddProductSuccess extends AddProductState {
  final ProductModel products;

  AddProductSuccess(this.products);
}
final class AddProductFailure extends AddProductState {
  final String message;

  AddProductFailure(this.message);
}
