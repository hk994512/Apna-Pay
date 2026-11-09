import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<int> onKeyTap;
  final VoidCallback onBackspace;

  const NumericKeypad({
    super.key,
    required this.onKeyTap,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row([1, 2, 3]),
          SizedBox(height: 8.h),
          _row([4, 5, 6]),
          SizedBox(height: 8.h),
          _row([7, 8, 9]),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(child: _digitKey(0)),
              Expanded(child: _backspaceKey()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(List<int> digits) {
    return Row(
      children: digits.map((d) => Expanded(child: _digitKey(d))).toList(),
    );
  }

  Widget _digitKey(int d) {
    return InkWell(
      onTap: () => onKeyTap(d),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 60.h,
        alignment: Alignment.center,
        child: Text(
          '$d',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _backspaceKey() {
    return InkWell(
      onTap: onBackspace,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 60.h,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          size: 26.r,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
