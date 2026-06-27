import 'package:flutter/material.dart';

import '../../../sale_history/data/models/sale_item_model.dart';
import '../../../stock_receipts/data/models/supplier_ref.dart';
import '../models/business_insight.dart';
import '../models/dashboard_summary.dart';
import '../models/low_stock_product.dart';
import '../models/quick_action.dart';
import '../models/recent_sale.dart';
import '../models/recent_stock_entry.dart';
import '../models/top_selling_product.dart';

class DashboardMockData {
  DashboardMockData._();

  static DashboardSummary get summary => const DashboardSummary(
        todayRevenue: 12450,
        yesterdayRevenue: 11116,
        todayOrders: 57,
        avgOrderValue: 218,
        totalProducts: 245,
        activeCategories: 12,
        lowStockCount: 8,
        inventoryValue: 128500,
        inventoryTurnoverChange: 14.2,
      );

  static List<QuickAction> get quickActions => const [
        QuickAction(
          id: 'new_sale',
          title: 'New Sale',
          description: 'Process a direct sale transaction',
          icon: Icons.shopping_cart_outlined,
          iconColor: Color(0xFF0041C8),
          iconBackground: Color(0xFFDCE1FF),
        ),
        QuickAction(
          id: 'new_stock_entry',
          title: 'New Stock Entry',
          description: 'Log arrival of new shipments',
          icon: Icons.move_to_inbox_outlined,
          iconColor: Color(0xFF1B6E3C),
          iconBackground: Color(0xFFD6F4E3),
        ),
        QuickAction(
          id: 'add_product',
          title: 'Add Product',
          description: 'Register a new SKU in catalog',
          icon: Icons.add_box_outlined,
          iconColor: Color(0xFF7B3C00),
          iconBackground: Color(0xFFFFE4CC),
        ),
        QuickAction(
          id: 'view_inventory',
          title: 'View Inventory',
          description: 'Full stock list & stocktaking',
          icon: Icons.inventory_2_outlined,
          iconColor: Color(0xFF505F76),
          iconBackground: Color(0xFFD0E1FB),
        ),
      ];

  static List<TopSellingProduct> get topSellingProducts => const [
        TopSellingProduct(
          id: '1',
          name: 'Apex Wireless v2',
          sku: 'APX-W2-BL',
          unitsSold: 142,
          revenue: 18460,
          performancePercent: 0.92,
        ),
        TopSellingProduct(
          id: '2',
          name: 'Tactile Mech Pro',
          sku: 'KBD-TM-PR',
          unitsSold: 98,
          revenue: 14210,
          performancePercent: 0.74,
        ),
        TopSellingProduct(
          id: '3',
          name: 'HydroFlow 1L',
          sku: 'BOT-HF-1L',
          unitsSold: 84,
          revenue: 2520,
          performancePercent: 0.61,
        ),
        TopSellingProduct(
          id: '4',
          name: 'ErgoStand Pro',
          sku: 'STD-ERG-BK',
          unitsSold: 61,
          revenue: 9150,
          performancePercent: 0.45,
        ),
        TopSellingProduct(
          id: '5',
          name: 'ClearView Monitor',
          sku: 'MON-CV-24',
          unitsSold: 39,
          revenue: 19500,
          performancePercent: 0.31,
        ),
      ];

  static List<LowStockProduct> get lowStockProducts => const [
        LowStockProduct(
          id: '1',
          name: 'Ergo Chair Lite – Obsidian',
          currentStock: 2,
          minimumStock: 10,
          status: LowStockStatus.critical,
        ),
        LowStockProduct(
          id: '2',
          name: 'Desk Mat – Felt Grey',
          currentStock: 5,
          minimumStock: 15,
          status: LowStockStatus.warning,
        ),
        LowStockProduct(
          id: '3',
          name: 'USB-C Hub (7-in-1)',
          currentStock: 1,
          minimumStock: 5,
          status: LowStockStatus.critical,
        ),
        LowStockProduct(
          id: '4',
          name: 'Wireless Charging Pad',
          currentStock: 0,
          minimumStock: 8,
          status: LowStockStatus.outOfStock,
        ),
        LowStockProduct(
          id: '5',
          name: 'Laptop Stand Aluminum',
          currentStock: 3,
          minimumStock: 12,
          status: LowStockStatus.warning,
        ),
      ];

  static List<RecentSale> get recentSales => [
        RecentSale(
          id: '#INV-4921',
          date: DateTime(2024, 10, 24, 14, 15),
          cashier: 'Ahmed S.',
          amount: 850,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4920',
          date: DateTime(2024, 10, 24, 13, 55),
          cashier: 'Maria K.',
          amount: 1200,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4919',
          date: DateTime(2024, 10, 24, 12, 30),
          cashier: 'Ahmed S.',
          amount: 450,
          status: SaleStatus.refunded,
        ),
        RecentSale(
          id: '#INV-4918',
          date: DateTime(2024, 10, 24, 11, 10),
          cashier: 'Sara M.',
          amount: 2100,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4917',
          date: DateTime(2024, 10, 24, 10, 45),
          cashier: 'Omar H.',
          amount: 680,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4916',
          date: DateTime(2024, 10, 24, 10, 02),
          cashier: 'Maria K.',
          amount: 320,
          status: SaleStatus.cancelled,
        ),
        RecentSale(
          id: '#INV-4915',
          date: DateTime(2024, 10, 24, 9, 30),
          cashier: 'Ahmed S.',
          amount: 950,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4914',
          date: DateTime(2024, 10, 24, 9, 05),
          cashier: 'Sara M.',
          amount: 1750,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4913',
          date: DateTime(2024, 10, 23, 18, 40),
          cashier: 'Omar H.',
          amount: 430,
          status: SaleStatus.completed,
        ),
        RecentSale(
          id: '#INV-4912',
          date: DateTime(2024, 10, 23, 17, 55),
          cashier: 'Ahmed S.',
          amount: 1620,
          status: SaleStatus.refunded,
        ),
      ];

  static List<RecentStockEntry> get recentStockEntries => [
        RecentStockEntry(
          receiptId: '#STK-0192',
          supplier: SupplierRef(id: '1',name: 'TechCore Ltd.',),
          totalCost: 12500,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 24, 13, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0191',
          supplier:SupplierRef(id: '1',name:'Global Logistics',),
          totalCost: 4200,
          status: StockEntryStatus.inTransit,
          date: DateTime(2024, 10, 24, 10, 30),
        ),
        RecentStockEntry(
          receiptId: '#STK-0190',
          supplier: SupplierRef(id: '1',name:'ErgoDesign Co.',),
          totalCost: 8900,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 23, 16, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0189',
          supplier: SupplierRef(id: '1',name:'NovaTech Egypt',),
          totalCost: 21300,
          status: StockEntryStatus.pending,
          date: DateTime(2024, 10, 23, 11, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0188',
          supplier: SupplierRef(id: '1',name:'SoundWave Imports',),
          totalCost: 6750,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 22, 14, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0187',
          supplier: SupplierRef(id: '1',name:'TechCore Ltd.',),
          totalCost: 9100,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 22, 9, 30),
        ),
        RecentStockEntry(
          receiptId: '#STK-0186',
          supplier: SupplierRef(id: '1',name:'ApexSupply',),
          totalCost: 3400,
          status: StockEntryStatus.cancelled,
          date: DateTime(2024, 10, 21, 15, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0185',
          supplier: SupplierRef(id: '1',name:'Global Logistics',),
          totalCost: 7200,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 21, 10, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0184',
          supplier: SupplierRef(id: '1',name:'ErgoDesign Co.',),
          totalCost: 15600,
          status: StockEntryStatus.inTransit,
          date: DateTime(2024, 10, 20, 14, 0),
        ),
        RecentStockEntry(
          receiptId: '#STK-0183',
          supplier: SupplierRef(id: '1',name:'NovaTech Egypt',),
          totalCost: 5800,
          status: StockEntryStatus.received,
          date: DateTime(2024, 10, 20, 9, 0),
        ),
      ];

  static List<BusinessInsight> get businessInsights => const [
        BusinessInsight(
          id: '1',
          title: 'Sales up 14% today',
          description:
              'Revenue is trending above the 30-day daily average. Peak hours between 10 AM and 2 PM.',
          icon: Icons.trending_up_rounded,
          severity: InsightSeverity.info,
        ),
        BusinessInsight(
          id: '2',
          title: 'Reorder Apex Wireless',
          description:
              'Stock will deplete in ~2 days at current sell rate. Reorder now to avoid stockout.',
          icon: Icons.inventory_2_outlined,
          severity: InsightSeverity.warning,
        ),
        BusinessInsight(
          id: '3',
          title: '3 Delayed Shipments',
          description:
              'Suppliers Global Logistics, NovaTech, and ApexSupply have shipments pending over 48 hours.',
          icon: Icons.local_shipping_outlined,
          severity: InsightSeverity.alert,
        ),
        BusinessInsight(
          id: '4',
          title: 'Top category: Electronics',
          description:
              'Electronics account for 42% of today\'s revenue, up from 36% last week.',
          icon: Icons.bar_chart_rounded,
          severity: InsightSeverity.info,
        ),
        BusinessInsight(
          id: '5',
          title: 'Margin improvement detected',
          description:
              'Gross margin improved by 2.3% this week due to bulk purchase discounts from TechCore.',
          icon: Icons.auto_graph_rounded,
          severity: InsightSeverity.info,
        ),
      ];

  /// Weekly revenue data points (last 7 days), Mon–Sun
  static List<double> get weeklyRevenue =>
      [8400, 9200, 7800, 11300, 10650, 9900, 12450];

  /// Weekly orders data points
  static List<double> get weeklyOrders =>
      [38, 44, 31, 59, 52, 47, 57];
}
