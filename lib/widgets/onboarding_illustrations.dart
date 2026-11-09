import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

// ─────────────────────────────────────────────────
// SLIDE 1 — "Send money" illustration
// ─────────────────────────────────────────────────
class SendMoneyIllustration extends StatelessWidget {
  const SendMoneyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background concentric circles
          _circle(300.r, const Color(0xFFEFF4FB)),
          _circle(230.r, const Color(0xFFE1EAF7)),
          _circle(170.r, const Color(0xFFD1DDF1)),

          // Center card
          Container(
            width: 200.w,
            padding: .all(18.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: .circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _avatar('MH', AppColors.primaryNavy),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primaryNavy,
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    _avatar('AK', const Color(0xFF7C5CFF)),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  'Rs. 5,000',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9F2E1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.green,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Sent instantly',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating pills
          Positioned(
            top: 20.h,
            left: 20.w,
            child: _pill(
              Icons.account_balance_rounded,
              'Any bank',
              AppColors.primaryNavy,
            ),
          ),
          Positioned(
            top: 60.h,
            right: 10.w,
            child: _pill(Icons.badge_rounded, 'CNIC', AppColors.primaryNavy),
          ),
          Positioned(
            bottom: 30.h,
            left: 20.w,
            child: _pill(Icons.bolt_rounded, 'Instant', AppColors.primaryNavy),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String label, Color color) {
    return Container(
      height: 46.r,
      width: 46.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _pill(IconData icon, String label, Color color) {
    return Container(
      padding: .symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SLIDE 2 — "Every bill" illustration
// ─────────────────────────────────────────────────
class EveryBillIllustration extends StatelessWidget {
  const EveryBillIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 320.r,
            width: 320.r,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF4FB),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 250.r,
            width: 250.r,
            decoration: const BoxDecoration(
              color: Color(0xFFE1EAF7),
              shape: BoxShape.circle,
            ),
          ),

          // Center white card with 4 category tiles
          Container(
            width: 210.w,
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _billTile(
                        Icons.bolt_rounded,
                        const Color(0xFFFDEBD3),
                        const Color(0xFFF59E0B),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _billTile(
                        Icons.local_gas_station_rounded,
                        const Color(0xFFFBE9E7),
                        const Color(0xFFE64A19),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _billTile(
                        Icons.water_drop_rounded,
                        const Color(0xFFE1F5FE),
                        const Color(0xFF039BE5),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _billTile(
                        Icons.wifi_rounded,
                        const Color(0xFFEDE4FB),
                        const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Floating pills
          Positioned(
            top: 40.h,
            right: 30.w,
            child: _pill(
              Icons.check_circle_rounded,
              'Paid',
              AppColors.green,
              bg: const Color(0xFFD9F2E1),
            ),
          ),
          Positioned(
            top: 90.h,
            left: 20.w,
            child: _pill(
              Icons.bookmark_rounded,
              'Saved bills',
              AppColors.primaryNavy,
            ),
          ),
          Positioned(
            bottom: 60.h,
            left: 30.w,
            child: _pill(
              Icons.notifications_active_rounded,
              'Due reminders',
              AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _billTile(IconData icon, Color bg, Color fg) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(icon, color: fg, size: 32.r),
      ),
    );
  }

  Widget _pill(IconData icon, String label, Color color, {Color? bg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SLIDE 3 — "Security" illustration
// ─────────────────────────────────────────────────
class SecurityIllustration extends StatelessWidget {
  const SecurityIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 320.r,
            width: 320.r,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF4FB),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 250.r,
            width: 250.r,
            decoration: const BoxDecoration(
              color: Color(0xFFE1EAF7),
              shape: BoxShape.circle,
            ),
          ),

          // Center navy circle with shield
          Container(
            height: 170.r,
            width: 170.r,
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 70.r,
            ),
          ),

          // Floating pills
          Positioned(
            top: 40.h,
            left: 20.w,
            child: _pill(
              Icons.fingerprint_rounded,
              'Biometric',
              AppColors.primaryNavy,
            ),
          ),
          Positioned(
            top: 70.h,
            right: 20.w,
            child: _pill(Icons.lock_rounded, 'MPIN', AppColors.primaryNavy),
          ),
          Positioned(
            bottom: 60.h,
            right: 40.w,
            child: _pill(
              Icons.verified_rounded,
              'NADRA verified',
              const Color(0xFF0B6FA4),
              bg: const Color(0xFFD4EAF7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String label, Color color, {Color? bg}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
