import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../data/mobile_load_data.dart';

class MobileLoadScreen extends StatefulWidget {
  const MobileLoadScreen({super.key});

  @override
  State<MobileLoadScreen> createState() => _MobileLoadScreenState();
}

class _MobileLoadScreenState extends State<MobileLoadScreen> {
  final _numberCtrl = TextEditingController(text: MobileLoadData.defaultNumber);
  final _amountCtrl = TextEditingController();

  int _networkIndex = 0;        // default Jazz
  int _tabIndex = 0;            // 0 = Prepaid load, 1 = Bundles
  int? _selectedAmount;

  @override
  void dispose() {
    _numberCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _numberCtrl.text.trim().isNotEmpty &&
      (_selectedAmount != null || _amountCtrl.text.trim().isNotEmpty);

  void _onContinue() {
    FocusScope.of(context).unfocus();
    // TODO: real API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loading Rs. ${_selectedAmount ?? _amountCtrl.text} '
          'on ${MobileLoadData.networks[_networkIndex].name}',
        ),
      ),
    );
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
                        'Mobile Load & Bundles',
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

            // ── Scrollable body ────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number + network picker card
                    _buildPhoneCard(),
                    SizedBox(height: 16.h),

                    // Tab switcher: Prepaid load / Bundles
                    _buildTabSwitcher(),
                    SizedBox(height: 16.h),

                    // Amounts grid / bundles list
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _tabIndex == 0
                          ? _buildAmountsGrid()
                          : _buildBundlesPlaceholder(),
                    ),
                    SizedBox(height: 16.h),

                    // Custom amount input
                    if (_tabIndex == 0) _buildCustomAmount(),
                    if (_tabIndex == 0) SizedBox(height: 14.h),

                    // Tax note
                    _buildTaxNote(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // ── Sticky bottom CTA ──────────────────
            _buildBottomCta(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Phone + network card
  // ─────────────────────────────────────────────
  Widget _buildPhoneCard() {
    return Container(
      padding: EdgeInsets.all(14.r),
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
        children: [
          // Phone input
          Container(
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
                Icon(Icons.smartphone_rounded,
                    color: AppColors.textGrey, size: 20.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _numberCtrl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                      hintText: '03XX XXXXXXX',
                      hintStyle: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ),
                ),
                Icon(Icons.person_outline_rounded,
                    color: AppColors.primaryNavy, size: 20.r),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Network selector
          Row(
            children: List.generate(MobileLoadData.networks.length, (i) {
              final n = MobileLoadData.networks[i];
              final selected = _networkIndex == i;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: GestureDetector(
                    onTap: () => setState(() => _networkIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: selected ? n.bgColor : const Color(0xFFF4F6FA),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: selected ? n.borderColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 32.r,
                            width: 32.r,
                            decoration: BoxDecoration(
                              color: n.brandColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              n.letter,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            n.name,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColors.textDark
                                  : AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Tab switcher (Prepaid load / Bundles)
  // ─────────────────────────────────────────────
  Widget _buildTabSwitcher() {
    const tabs = [
      ('Prepaid load', Icons.bolt_rounded),
      ('Bundles', Icons.wifi_rounded),
    ];

    return Row(
      children: List.generate(tabs.length, (i) {
        final selected = _tabIndex == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: GestureDetector(
              onTap: () => setState(() {
                _tabIndex = i;
                _selectedAmount = null;
                _amountCtrl.clear();
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 52.h,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF111827) : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8.r,
                            offset: Offset(0, 4.h),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tabs[i].$2,
                      color: selected ? Colors.white : AppColors.textDark,
                      size: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      tabs[i].$1,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // Prepaid amounts grid (3 × 2)
  // ─────────────────────────────────────────────
  Widget _buildAmountsGrid() {
    return GridView.builder(
      key: const ValueKey('amounts'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: MobileLoadData.prepaidAmounts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        mainAxisExtent: 56.h,
      ),
      itemBuilder: (context, i) {
        final amount = MobileLoadData.prepaidAmounts[i];
        final selected = _selectedAmount == amount;

        return GestureDetector(
          onTap: () => setState(() {
            _selectedAmount = amount;
            _amountCtrl.clear();
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryNavy : Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: selected
                    ? AppColors.primaryNavy
                    : AppColors.textLightGrey.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryNavy.withOpacity(0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              'Rs. ${_formatAmount(amount)}',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Bundles placeholder (tab 2)
  // ─────────────────────────────────────────────
  Widget _buildBundlesPlaceholder() {
    return Container(
      key: const ValueKey('bundles'),
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.textLightGrey.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_rounded,
              size: 40.r, color: AppColors.textLightGrey),
          SizedBox(height: 10.h),
          Text(
            'Bundles coming soon',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Daily, weekly and monthly bundles\nfrom all networks',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Custom amount field
  // ─────────────────────────────────────────────
  Widget _buildCustomAmount() {
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
          Icon(Icons.edit_outlined,
              color: AppColors.textGrey, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (_) => setState(() {
                if (_amountCtrl.text.isNotEmpty) _selectedAmount = null;
              }),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                hintText: 'Other amount (Rs. 50 to 5,000)',
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
  // Tax note
  // ─────────────────────────────────────────────
  Widget _buildTaxNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded,
            color: AppColors.textGrey, size: 16.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Tax is deducted by the operator. Load arrives in seconds.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Bottom CTA — dynamic label & enable state
  // ─────────────────────────────────────────────
  Widget _buildBottomCta() {
    final enabled = _canSubmit;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SizedBox(
        height: 60.h,
        child: ElevatedButton(
          onPressed: enabled ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryNavy,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
                AppColors.primaryNavy.withOpacity(0.35),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 4.w),
              Container(
                height: 52.r,
                width: 52.r,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryNavy,
                  size: 24.r,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _bottomLabel(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  color: Colors.white,
                  size: 22.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _bottomLabel() {
    if (_selectedAmount != null) return 'Load Rs. ${_formatAmount(_selectedAmount!)}';
    if (_amountCtrl.text.trim().isNotEmpty) {
      return 'Load Rs. ${_amountCtrl.text.trim()}';
    }
    return 'Choose an amount';
  }

  // ─────────────────────────────────────────────
  // Helpers
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

  static String _formatAmount(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}