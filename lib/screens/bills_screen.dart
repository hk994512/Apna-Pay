import 'package:apna_pay/data/bill_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title + subtitle ──────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pay Bills', style: AppTextStyles.h1),
                        SizedBox(height: 6.h),
                        Text(
                          'Electricity, gas, water, internet and more',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const _RoundIconButton(icon: 'assets/history-broken.svg'),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // ── Upcoming bills banner ──────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const _UpcomingBillsBanner(),
            ),
            SizedBox(height: 26.h),

            // ── Categories ─────────────────────────
            const _SectionTitle(title: 'Categories'),
            SizedBox(height: 14.h),
            const _CategoriesGrid(),
            SizedBox(height: 26.h),

            // ── Saved bills ────────────────────────
            const _SectionTitle(title: 'Saved bills', action: 'See all'),
            SizedBox(height: 14.h),
            ...BillsData.savedBills.map(
              (b) => Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                child: _SavedBillCard(bill: b),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SMALL SHARED WIDGETS
// ─────────────────────────────────────────────────
class _RoundIconButton extends StatelessWidget {
  final String icon;
  const _RoundIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Container(
          height: 44.r,
          width: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: SvgPicture.asset(
            icon,
            color: AppColors.primaryNavy,
            height: 22.r,
          ),

          // Icon(icon, color: AppColors.primaryNavy, size: 22.r),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  const _SectionTitle({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.h3)),
          if (action != null)
            GestureDetector(
              onTap: () {},
              child: Text(
                action!,
                style: TextStyle(
                  color: AppColors.primaryNavy,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// UPCOMING BILLS BANNER
// ─────────────────────────────────────────────────
class _UpcomingBillsBanner extends StatelessWidget {
  const _UpcomingBillsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB45309), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.35),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -30.w,
            top: -30.h,
            child: Container(
              height: 120.r,
              width: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            right: 40.w,
            bottom: -40.h,
            child: Container(
              height: 90.r,
              width: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: .all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming bills',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              BillsData.totalDue,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      height: 56.r,
                      width: 56.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/notification-bell-outline.svg',
                        color: AppColors.primaryNavy,
                        height: 22.r,
                      ),
                      // Icon(
                      //   Icons.notifications_active_outlined,
                      //   color: Colors.white,
                      //   size: 26.r,
                      // ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _BannerChip(
                      icon: 'assets/sim.svg',
                      text: '${BillsData.savedCount} saved bills',
                    ),
                    const _BannerChip(
                      icon: 'assets/electricity-outline.svg',
                      text: '5% cashback on electricity',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerChip extends StatelessWidget {
  final String icon;
  final String text;
  const _BannerChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(icon, color: Colors.white, height: 25.r),
          // Icon(icon, color: Colors.white, size: 13.r),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// CATEGORIES GRID (3 columns, fixed cell height)
// ─────────────────────────────────────────────────
class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: BillsData.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          mainAxisExtent: 112.h,
        ),
        itemBuilder: (context, i) => _CategoryTile(
          category: BillsData.categories[i],
          onTap: (context) => BillsData.categories[i].onPress(context),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final BillCategory category;
  const _CategoryTile({required this.category, required this.onTap(context)});
  final void Function(BuildContext context) onTap;
  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: () => onTap(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50.r,
                  width: 50.r,
                  decoration: BoxDecoration(
                    color: category.bg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: SvgPicture.asset(
                    category.icon,
                    color: category.fg,
                    height: 25.r,
                  ),
                  // Icon(category.icon, color: category.fg, size: 25.r),
                ),
                SizedBox(height: 8.h),
                Flexible(
                  child: Text(
                    category.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SAVED BILL CARD
// ─────────────────────────────────────────────────
class _SavedBillCard extends StatelessWidget {
  final SavedBill bill;
  const _SavedBillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);
    final hasDue = bill.dueText != null;
    final accent = bill.isOverdue
        ? AppColors.red
        : (hasDue ? AppColors.green : Colors.transparent);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Stack(
              children: [
                // Status accent stripe
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4.w, color: accent),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 14.w, 14.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Provider avatar
                      Container(
                        height: 52.r,
                        width: 52.r,
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: bill.providerBg,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            bill.provider,
                            style: TextStyle(
                              color: bill.providerFg,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Title + provider · masked id + status chip
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bill.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    bill.provider,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                  ),
                                  child: Container(
                                    height: 3.r,
                                    width: 3.r,
                                    decoration: const BoxDecoration(
                                      color: AppColors.textGrey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '•••• ${bill.consumerId}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (hasDue) ...[
                              SizedBox(height: 8.h),
                              _StatusChip(
                                text: bill.dueText!,
                                overdue: bill.isOverdue,
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Amount + Pay button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              bill.amount,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 34.h,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bill.isOverdue
                                    ? AppColors.red
                                    : AppColors.primaryNavy,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: Text(
                                'Pay',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final bool overdue;
  const _StatusChip({required this.text, required this.overdue});

  @override
  Widget build(BuildContext context) {
    final fg = overdue ? AppColors.red : AppColors.green;
    final bg = overdue ? const Color(0xFFFDE7E7) : AppColors.softGreen;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            overdue ? Icons.error_outline_rounded : Icons.schedule_rounded,
            size: 12.r,
            color: fg,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
