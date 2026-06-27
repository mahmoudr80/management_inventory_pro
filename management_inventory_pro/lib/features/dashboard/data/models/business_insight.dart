import 'package:flutter/material.dart';

enum InsightSeverity { info, warning, alert }

class BusinessInsight {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final InsightSeverity severity;

  const BusinessInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.severity,
  });
}
