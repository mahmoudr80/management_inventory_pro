enum AdjustmentReason {
  inventoryCount,
  damaged,
  expired,
  lost,
  theft,
  correction,
  sample,
  other;

  String get label => switch (this) {
        AdjustmentReason.inventoryCount => 'Inventory Count',
        AdjustmentReason.damaged => 'Damaged',
        AdjustmentReason.expired => 'Expired',
        AdjustmentReason.lost => 'Lost',
        AdjustmentReason.theft => 'Theft',
        AdjustmentReason.correction => 'Correction',
        AdjustmentReason.sample => 'Sample',
        AdjustmentReason.other => 'Other',
      };
}
