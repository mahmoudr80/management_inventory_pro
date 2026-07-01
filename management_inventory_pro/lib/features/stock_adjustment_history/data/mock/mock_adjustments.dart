import 'dart:math';

import '../models/adjustment_model.dart';
import '../models/adjustment_reason.dart';
import '../models/adjustment_status.dart';
import '../models/product_adjustment_model.dart';

/// Generates a realistic, deterministic-ish mock dataset for the Stock
/// Adjustment History screen. No SQLite / persistence involved.
class MockAdjustments {
  MockAdjustments._();

  static const _catalog = <(String name, String skuPrefix)>[
    ('MacBook Pro 14" M3', 'SKU-LAP-001'),
    ('Dell UltraSharp 27"', 'SKU-MON-024'),
    ('Logitech MX Master 3S', 'SKU-ACC-992'),
    ('AirPods Pro Gen 2', 'SKU-AUD-501'),
    ('iPhone 15 Pro 256GB', 'SKU-PHN-118'),
    ('Samsung Galaxy Tab S9', 'SKU-TAB-077'),
    ('HP LaserJet Pro M404', 'SKU-PRN-205'),
    ('Sony WH-1000XM5', 'SKU-AUD-330'),
    ('Keychron K8 Keyboard', 'SKU-ACC-410'),
    ('LG 34" UltraWide Monitor', 'SKU-MON-188'),
    ('Anker PowerCore 20K', 'SKU-PWR-067'),
    ('Razer DeathAdder V3', 'SKU-ACC-512'),
    ('iPad Air 5th Gen', 'SKU-TAB-091'),
    ('Bose QuietComfort Earbuds', 'SKU-AUD-244'),
    ('Western Digital 2TB SSD', 'SKU-STR-356'),
    ('Microsoft Surface Dock 2', 'SKU-ACC-679'),
    ('Canon EOS R50 Camera', 'SKU-CAM-022'),
    ('Jabra Evolve2 65 Headset', 'SKU-AUD-498'),
  ];

  static const _employees = ['Ahmed Ali', 'Sara Soliman', 'Khaled Mohamed'];

  /// Builds 15–20 mock adjustment records spanning the last 30 days.
  static List<AdjustmentModel> generate({int count = 18, int seed = 42}) {
    final random = Random(seed);
    final now = DateTime.now();

    return List.generate(count, (index) {
      final reason = AdjustmentReason.values[
          random.nextInt(AdjustmentReason.values.length)];
      final status = _statusFor(index, random);
      final createdBy = _employees[random.nextInt(_employees.length)];
      final dateTime = now.subtract(
        Duration(
          days: random.nextInt(30),
          hours: random.nextInt(23),
          minutes: random.nextInt(59),
        ),
      );

      final productCount = 1 + random.nextInt(12);
      final products = _generateProducts(random, productCount, reason);
      final valueImpact = products.fold<double>(
        0,
        (sum, product) => sum + (product.adjustmentQty * (40 + random.nextInt(260))),
      );

      return AdjustmentModel(
        id: 'ADJ-2024-${(124 - index).toString().padLeft(5, '0')}',
        dateTime: dateTime,
        reason: reason,
        status: status,
        createdBy: createdBy,
        valueImpact: double.parse(valueImpact.toStringAsFixed(2)),
        products: products,
      );
    })..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static AdjustmentStatus _statusFor(int index, Random random) {
    final roll = random.nextInt(100);
    if (roll < 70) return AdjustmentStatus.completed;
    if (roll < 90) return AdjustmentStatus.draft;
    return AdjustmentStatus.cancelled;
  }

  static List<ProductAdjustmentModel> _generateProducts(
    Random random,
    int count,
    AdjustmentReason reason,
  ) {
    final isLoss = reason == AdjustmentReason.damaged ||
        reason == AdjustmentReason.expired ||
        reason == AdjustmentReason.theft ||
        reason == AdjustmentReason.lost;

    final shuffled = List.of(_catalog)..shuffle(random);
    return List.generate(count, (i) {
      final item = shuffled[i % shuffled.length];
      final previousStock = 10 + random.nextInt(200);

      int delta;
      if (isLoss) {
        delta = -(1 + random.nextInt(20));
      } else if (reason == AdjustmentReason.inventoryCount) {
        delta = random.nextInt(2) == 0
            ? 1 + random.nextInt(30)
            : -(1 + random.nextInt(15));
      } else {
        delta = random.nextInt(2) == 0
            ? 1 + random.nextInt(10)
            : -(1 + random.nextInt(10));
      }
      delta = delta.clamp(-previousStock, 999);

      return ProductAdjustmentModel(
        productName: item.$1,
        sku: '${item.$2}-${(100 + i + random.nextInt(50))}',
        adjustmentQty: delta,
        previousStock: previousStock,
      );
    });
  }
}
