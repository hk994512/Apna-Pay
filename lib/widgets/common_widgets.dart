import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const SectionCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding == EdgeInsets.zero ? EdgeInsets.all(16.r) : padding,
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h3),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class IconTile extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final double size;

  const IconTile({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final s = size.r;
    return Container(
      height: s,
      width: s,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(s * 0.3),
      ),
      child: Icon(icon, color: iconColor, size: s * 0.5),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final String initials;
  final Color bgColor;
  final Color fgColor;
  final IconData? icon;

  const AvatarCircle({
    super.key,
    required this.initials,
    required this.bgColor,
    required this.fgColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.r,
      width: 48.r,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, color: fgColor, size: 24.r)
          : Text(
              initials,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
    );
  }
}
