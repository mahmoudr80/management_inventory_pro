
import 'package:management_inventory_pro/core/database/database_constants.dart';
import 'package:management_inventory_pro/features/sale_history/data/models/sale_item_model.dart';


class SaleModel {
  final String id;

  final List<SaleItemModel> items;

  final String? notes;

  final int ?discount;
  final int ?tax;

  final String cashierName;

  final PaymentMethod paymentMethod;

  final SaleStatus status;

  final DateTime createdAt;

  final DateTime updatedAt;

  const SaleModel({
    required this.id,
    required this.items,
    required this.cashierName,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes, this.discount=0, this.tax=0,
  });

  int get totalItems => items.length;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.total);

  bool get isCompleted => status == SaleStatus.completed;

  factory SaleModel.fromMap({required String saleId,required  Map<String, Object?>map}){
    return SaleModel(id: saleId,
      items: [],
      cashierName: (map[DatabaseConstants.cashierNameColumn]??'Admin') as String,

      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name.toLowerCase() ==
            ((map[DatabaseConstants.paymentMethodColumn]??'Cash') as String).toLowerCase(),
      ),

      status: SaleStatus.values.firstWhere(
            (e) => e.name.toLowerCase() ==
            ((map[DatabaseConstants.statusColumn]??'Completed') as String).toLowerCase(),
      ),

      notes: map[DatabaseConstants.noteColumn] as String?,
      createdAt: DateTime.parse(
        map[DatabaseConstants.createdAtColumn] as String,
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String,
      ),);
  }
}