part of 'home_cubit.dart';
enum PageAction {
  none,
  createProduct,
  createStockEntry,
  selectStockEntry,
  selectSale,
  restock,
  newSale,
  productList,
}
@immutable
sealed class HomeState {
  final int currentIndex;
  final PageAction action;
  final ProductRef? restock;
  final StockEntryModel? selectEntry;
  final SaleModel? selectSale;


  const HomeState({required this.currentIndex, this.action = PageAction.none, this.restock, this.selectEntry, this.selectSale,});
}

final class HomeInitial extends HomeState {
  const HomeInitial():super(currentIndex:  0);

}
final class NavigateState extends HomeState {
  const NavigateState({required super.currentIndex, PageAction ?action,super.restock,super.selectEntry,super.selectSale}) :
        super(action: action??PageAction.none);
}
