import '../../../../core/networking/api_result.dart';
import '../datasource/pos_datasource.dart';
import '../models/cart_item.dart';

class PosRepository{
  final PosDatasource _datasource;
  const PosRepository (this._datasource);

  Future <ApiResult> completeSale(CartModel cart) async {
    return await _datasource.completeSale(cart);
  }
}