import '../../domain/repositories/i_stock_adjustment_history_repository.dart';
import '../mock/mock_adjustments.dart';
import '../models/adjustment_model.dart';

/// Mock repository — no SQLite, no network. Returns a realistic, generated
/// dataset after a short simulated latency.
class MockStockAdjustmentHistoryRepository
    implements IStockAdjustmentHistoryRepository {
  @override
  Future<List<AdjustmentModel>> getAdjustments() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return MockAdjustments.generate();
  }
}
