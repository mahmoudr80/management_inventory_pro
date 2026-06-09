import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/components/page_header.dart';
import '../cubit/product_cubit.dart';
import '../widgets/add_product_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed desktop layout – no platform branching
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Add New Product',
                subtitle: 'Create a new entry in the inventory master database.',
              ),
              const SizedBox(height: 24),
              // Form container with glass‑morphism effect
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(//The background behind the widget becomes blurred.
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(140),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const AddProductForm(),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }}
