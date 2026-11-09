import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../data/company_data.dart';

class CompanyListScreen extends StatefulWidget {
  final CompanyCategory category;

  const CompanyListScreen({super.key, required this.category});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final _searchCtrl = TextEditingController();
  late List<Company> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.category.companies;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = widget.category.companies;
      } else {
        _filtered = widget.category.companies.where((c) {
          return c.code.toLowerCase().contains(q) ||
              c.fullName.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Row(
                children: [
                  _circleBackButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.category.title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 44.r),
                ],
              ),
            ),

            // ── Search bar ─────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _searchBar(),
            ),
            SizedBox(height: 16.h),

            // ── Company list ───────────────────────
            Expanded(
              child: _filtered.isEmpty
                  ? _emptyState()
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
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
                          children: List.generate(_filtered.length, (i) {
                            final isLast = i == _filtered.length - 1;
                            return Column(
                              children: [
                                _companyTile(_filtered[i]),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    indent: 76.w,
                                    endIndent: 16.w,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Back button
  // ─────────────────────────────────────────────
  Widget _circleBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
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
          Icons.chevron_left_rounded,
          color: AppColors.textDark,
          size: 26.r,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Search bar
  // ─────────────────────────────────────────────
  Widget _searchBar() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textLightGrey.withOpacity(0.25)),
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
              controller: _searchCtrl,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                hintText: widget.category.searchHint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textLightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Company tile
  // ─────────────────────────────────────────────
  Widget _companyTile(Company c) {
    return InkWell(
      onTap: () {
        // TODO: navigate to bill form for this company
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${c.code} selected')));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Brand tile
            Container(
              height: 52.r,
              width: 52.r,
              decoration: BoxDecoration(
                color: c.brandColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: Text(
                c.code,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // Code + full name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    c.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textLightGrey,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Empty state (search returned nothing)
  // ─────────────────────────────────────────────
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56.r,
              color: AppColors.textLightGrey,
            ),
            SizedBox(height: 12.h),
            Text(
              'No companies found',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Try a different search term',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
