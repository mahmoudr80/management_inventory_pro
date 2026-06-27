import 'package:bloc/bloc.dart';
import 'package:management_inventory_pro/features/dashboard/data/models/low_stock_product.dart';
import 'package:management_inventory_pro/features/dashboard/data/models/recent_sale.dart';
import 'package:management_inventory_pro/features/dashboard/data/models/recent_stock_entry.dart';
import 'package:management_inventory_pro/features/sale_history/data/models/sale_item_model.dart';
import 'package:management_inventory_pro/features/sale_history/data/models/sale_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_line_model.dart';
import 'package:management_inventory_pro/features/stock_receipts/data/models/stock_entry_model.dart';
import 'package:meta/meta.dart';

import '../../stock_receipts/data/models/product_ref.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void navigate(int index){
    if(index!=state.currentIndex){
      emit(NavigateState(currentIndex:  index));
    }
  }
  void openProductsForCreate() {
    emit(
      NavigateState(currentIndex: 1,action: PageAction.createProduct )
    );
  }  void openProductList() {
    emit(
      NavigateState(currentIndex: 1,action: PageAction.productList )
    );
  }
  void openStockEntryForCreate() {
    emit(
        NavigateState(currentIndex: 3,action: PageAction.createStockEntry )
    );
  }
  void selectEntry(RecentStockEntry entry) {
    emit(
        NavigateState(currentIndex: 3,action: PageAction.selectStockEntry, selectEntry:
        StockEntryModel(id: entry.receiptId, supplier:entry.supplier, receiptDate: entry.date,
            lines:entry.items.map((e) => StockEntryLineModel(id: e.id, product:
            e.product, quantity: e.quantity, unitCost: e.unitCost),).toList()
        ) )
    );
  }
  void selectSale(RecentSale sale) {
    emit(
        NavigateState(currentIndex: 5,action: PageAction.selectSale, selectSale:
        SaleModel(id: sale.id,
            items: sale.items.map((item) =>
                SaleItemModel(id: item.id, product: item.product, quantity: item.quantity,
                    sellingPrice: item.sellingPrice) ,).toList(),
            cashierName: sale.cashier, paymentMethod: sale.paymentMethod, status: sale.status,
            createdAt: sale.date, updatedAt: sale.date)
         )
    );
  }

  void restock(LowStockProduct product) {
    emit(
        NavigateState(currentIndex: 3,action: PageAction.restock,restock: ProductRef(id: product.id, name:product.name) )
    );
  }
  void openNewSale() {
    emit(
        NavigateState(currentIndex: 4,action: PageAction.newSale )
    );
  }
  void clearAction() {
    NavigateState(currentIndex: state.currentIndex,action: PageAction.none );

  }
}
