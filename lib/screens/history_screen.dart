import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../data/history_data.dart';
import '../widgets/common_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchCtrl = TextEditingController();
  int _selectedFilter = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // ── Title row ───────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
            child: Row(
              children: [
                Text('Transactions', style: AppTextStyles.h1),
                const Spacer(),
                _StatementButton(),
              ],
            ),
          ),

          // ── Rest of the screen is scrollable ────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Summary cards ───────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Money in',
                            amount: 'Rs. 93,500',
                            icon: Icons.attach_money_rounded,
                            bg: AppColors.iconGreen,
                            fg: AppColors.green,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Money out',
                            amount: 'Rs. 29,459',
                            icon: Icons.send_rounded,
                            bg: AppColors.softPink,
                            fg: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Search bar ──────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _SearchBar(controller: _searchCtrl),
                  ),
                  SizedBox(height: 16.h),

                  // ── Filter chips (horizontal) ───
                  SizedBox(
                    height: 42.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: HistoryData.filters.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (_, i) => _FilterChip(
                        label: HistoryData.filters[i],
                        selected: _selectedFilter == i,
                        onTap: () => setState(() => _selectedFilter = i),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Grouped transactions ────────
                  ...HistoryData.groups.map((g) => _GroupSection(group: g)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// STATEMENT BUTTON (top-right icon)
// ─────────────────────────────────────────────────
class _StatementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.r,
      width: 44.r,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Icon(
        Icons.file_download_outlined,
        color: AppColors.textDark,
        size: 22.r,
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SUMMARY CARD (Money in / Money out)
// ─────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 38.r,
            width: 38.r,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: fg, size: 20.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SEARCH BAR
// ─────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: AppColors.textLightGrey,
            size: 22.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textDark),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                hintText: 'Search name, bill or bank',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textLightGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// FILTER CHIP
// ─────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GROUP SECTION (Today / Yesterday)
// ─────────────────────────────────────────────────
class _GroupSection extends StatelessWidget {
  final HistoryGroup group;
  const _GroupSection({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 10.h),
          child: Text(
            group.label,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SectionCard(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              children: List.generate(group.items.length, (i) {
                final t = group.items[i];
                final isLast = i == group.items.length - 1;
                return Column(
                  children: [
                    _TransactionTile(t: t),
                    if (!isLast)
                      Divider(height: 1, indent: 76.w, endIndent: 16.w),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// TRANSACTION TILE
// ─────────────────────────────────────────────────
class _TransactionTile extends StatelessWidget {
  final HistoryTransaction t;
  const _TransactionTile({required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          AvatarCircle(
            initials: t.initials,
            bgColor: t.avatarBg,
            fgColor: t.avatarFg,
            icon: t.icon,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  t.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            t.amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: t.isCredit ? AppColors.green : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
