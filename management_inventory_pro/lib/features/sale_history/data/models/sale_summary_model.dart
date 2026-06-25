import 'package:flutter/cupertino.dart';

class SalesSummaryModel {
  final double totalRevenue;
  final int totalOrders;
  final int totalItemsSold;
  final int totalQuantitySold;
  final double averageOrderValue;

  const SalesSummaryModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalItemsSold,
    required this.totalQuantitySold,
    required this.averageOrderValue,
  });
}
class SummaryCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String trend;
  final bool trendPositive;

  const SummaryCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.trend,
    required this.trendPositive,
  });
}