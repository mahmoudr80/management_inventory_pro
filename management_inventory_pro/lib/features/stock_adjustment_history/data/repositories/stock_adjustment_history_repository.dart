import '../mock/mock_adjustments.dart';
import '../models/adjustment_model.dart';


class StockAdjustmentHistoryRepository {
  Future<List<AdjustmentModel>> getAdjustments() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return MockAdjustments.generate();
  }
}
