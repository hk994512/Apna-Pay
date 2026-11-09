  
  import 'package:apna_pay/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.textLightGrey.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textGrey, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: [
                if (keyboardType == TextInputType.number)
                  FilteringTextInputFormatter.digitsOnly,
                if (maxLength != null)
                  LengthLimitingTextInputFormatter(maxLength),
              ],
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textLightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (suffixIcon != null) ...[
            SizedBox(width: 8.w),
            Icon(suffixIcon, color: AppColors.textGrey, size: 20.r),
          ],
        ],
      ),
    );
  }
