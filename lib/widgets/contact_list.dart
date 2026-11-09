import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget contactList({required List<Widget> items}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12.r,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: Column(
      children: List.generate(items.length, (i) {
        final isLast = i == items.length - 1;
        return Column(
          children: [
            items[i],
            if (!isLast) Divider(height: 1, indent: 76.w, endIndent: 16.w),
          ],
        );
      }),
    ),
  );
}
