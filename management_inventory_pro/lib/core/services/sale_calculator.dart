/// Immutable result of a tax/discount calculation for a single sale.
///
/// Always the source of truth for what a cart or a completed sale is
/// actually charging — never recompute tax from raw item totals anywhere
/// else in the app (widgets, cubits). Always go through [SaleCalculator].
class SaleTotals {
  /// Sum of all line items, tax-exclusive, before discount.
  /// When [pricesIncludeTax] was true at calculation time, this is the
  /// tax-exclusive amount backed out of the tax-inclusive cart total —
  /// i.e. always "what the customer pays before tax", regardless of how
  /// prices were entered.
  final double subtotal;

  final double discountAmount;
  final bool taxEnabled;

  /// The tax percentage applied. `0` when [taxEnabled] is false.
  final double taxPercentage;

  final double taxAmount;

  /// Final amount charged to the customer.
  final double grandTotal;

  const SaleTotals({
    required this.subtotal,
    required this.discountAmount,
    required this.taxEnabled,
    required this.taxPercentage,
    required this.taxAmount,
    required this.grandTotal,
  });

  /// Safe fallback used before settings finish loading, or when there is
  /// no cart yet.
  const SaleTotals.zero()
      : subtotal = 0,
        discountAmount = 0,
        taxEnabled = false,
        taxPercentage = 0,
        taxAmount = 0,
        grandTotal = 0;
}

/// Pure, stateless tax/discount math for the POS feature.
///
/// This is the *only* place tax is calculated anywhere in the app.
/// Widgets and cubits must never compute tax themselves — they call
/// [calculate] and render/persist the resulting [SaleTotals].
///
/// Business rules implemented (see feature spec):
///  * Tax disabled            → GrandTotal = Subtotal - Discount
///  * Tax enabled, exclusive  → Tax = (Subtotal - Discount) * Rate / 100
///                               GrandTotal = Subtotal - Discount + Tax
///  * Tax enabled, inclusive  → Tax = GrandTotal * Rate / (100 + Rate)
///                               Subtotal = GrandTotal - Tax
///    (here "GrandTotal" going into the inclusive formula is the raw
///    tax-inclusive cart total minus discount — see implementation.)
class SaleCalculator {
  SaleCalculator._();

  /// [subtotal] is always the raw sum of cart line totals (`price *
  /// quantity` for every item), *before* discount, exactly as priced in
  /// the catalog — regardless of whether those catalog prices are
  /// tax-inclusive or tax-exclusive. [pricesIncludeTax] tells this method
  /// how to interpret that number.
  static SaleTotals calculate({
    required double subtotal,
    double discountAmount = 0,
    required bool taxEnabled,
    required double taxPercentage,
    required bool pricesIncludeTax,
  }) {
    final safeSubtotal = subtotal < 0 ? 0.0 : subtotal;
    final safeDiscount = discountAmount < 0 ? 0.0 : discountAmount;

    if (!taxEnabled) {
      final grandTotal = safeSubtotal - safeDiscount;
      return SaleTotals(
        subtotal: safeSubtotal,
        discountAmount: safeDiscount,
        taxEnabled: false,
        taxPercentage: 0,
        taxAmount: 0,
        grandTotal: grandTotal < 0 ? 0 : grandTotal,
      );
    }

    if (pricesIncludeTax) {
      // Catalog prices already contain tax, so the raw cart total (minus
      // discount) IS the tax-inclusive grand total. Back the tax out of it.
      final taxInclusiveTotal = safeSubtotal - safeDiscount;
      final safeTotal = taxInclusiveTotal < 0 ? 0.0 : taxInclusiveTotal;
      final taxAmount = taxPercentage <= 0
          ? 0.0
          : safeTotal * taxPercentage / (100 + taxPercentage);

      // Displayed "Subtotal" must satisfy Subtotal - Discount + Tax = GrandTotal
      // for every discount value, not just 0. Since GrandTotal = R - D and
      // Tax is computed on that discounted total, the only value that keeps
      // the row math consistent is R - Tax (independent of D):
      //   (R - Tax) - D + Tax = R - D = GrandTotal  ✓
      final subtotalForDisplay = safeSubtotal - taxAmount;

      return SaleTotals(
        subtotal: subtotalForDisplay < 0 ? 0 : subtotalForDisplay,
        discountAmount: safeDiscount,
        taxEnabled: true,
        taxPercentage: taxPercentage,
        taxAmount: taxAmount < 0 ? 0 : taxAmount,
        grandTotal: safeTotal,
      );
    }

    // Tax enabled, catalog prices are tax-exclusive.
    final taxableAmount = safeSubtotal - safeDiscount;
    final safeTaxable = taxableAmount < 0 ? 0.0 : taxableAmount;
    final taxAmount = taxPercentage <= 0 ? 0.0 : safeTaxable * taxPercentage / 100;
    final grandTotal = safeTaxable + taxAmount;

    return SaleTotals(
      subtotal: safeSubtotal,
      discountAmount: safeDiscount,
      taxEnabled: true,
      taxPercentage: taxPercentage,
      taxAmount: taxAmount,
      grandTotal: grandTotal < 0 ? 0 : grandTotal,
    );


  }

}