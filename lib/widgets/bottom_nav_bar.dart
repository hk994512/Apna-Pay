import 'package:apna_pay/widgets/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NavItem(
                    icon: 'assets/house.svg',
                    label: 'Home',
                    selected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  NavItem(
                    icon: 'assets/history-broken.svg',
                    label: 'History',
                    selected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  SizedBox(width: 72.w),
                  NavItem(
                    icon: 'assets/bill.svg',
                    label: 'Bills',
                    selected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  NavItem(
                    icon: 'assets/profile-thin.svg',
                    label: 'Profile',
                    selected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  height: 62.r,
                  width: 62.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryNavy.withOpacity(0.35),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_2,
                    color: Colors.white,
                    size: 28.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
