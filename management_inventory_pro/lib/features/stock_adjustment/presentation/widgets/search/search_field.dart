import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final FocusNode focusNode;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: TextStyle(fontSize: 5.sp, color: const Color(0xFF131B2E)),
        decoration: InputDecoration(
          hintText: 'Search by SKU, Barcode, or Product Name...',
          hintStyle: TextStyle(fontSize: 5.sp, color: const Color(0xFF737688)),
          prefixIcon: Icon(Icons.search, size: 28.r, color: const Color(0xFF737688)),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, size: 28.r),
                  onPressed: onClear,
                  color: const Color(0xFF737688),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                    margin: EdgeInsetsGeometry.symmetric(vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEDFF),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: const Color(0xFFC3C5D9)),
                    ),
                    child: Text(
                      'F2',
                      style: TextStyle(
                        fontSize: 3.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF434656),
                      ),
                    ),
                  ),
                ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFC3C5D9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFC3C5D9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFF0041C8), width: 1.5),
          ),
        ),
      ),
    );
  }
}
