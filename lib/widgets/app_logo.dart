import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo tile
        Container(
          height: 44.r,
          width: 44.r,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Small card behind
              Positioned(
                top: 10.h,
                left: 8.w,
                child: Container(
                  height: 20.r,
                  width: 26.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              // Wallet emoji on top
              Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.primaryNavy,
                size: 26.r,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
            ),
            children: const [
              TextSpan(
                text: 'Apna',
                style: TextStyle(color: AppColors.primaryNavy),
              ),
              TextSpan(
                text: 'Pay',
                style: TextStyle(color: Color(0xFFF59E0B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
