import 'package:apna_pay/widgets/cnic_tab.dart';
import 'package:apna_pay/widgets/contact_list.dart';
import 'package:apna_pay/widgets/footer_note.dart';
import 'package:apna_pay/widgets/input_field.dart';
import 'package:apna_pay/widgets/label.dart';
import 'package:apna_pay/widgets/primary_btn.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../data/send_money_data.dart';

class BankTransfer extends StatefulWidget {
  const BankTransfer({super.key, required this.tabNumber});
  final int tabNumber;
  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.tabNumber.clamp(0, 2),
    );
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ─────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  _circleBackButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Send Money',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 44.r), // balance for back button
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Tab Bar ─────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTabBar(),
            ),
            SizedBox(height: 16.h),

            // ── Tab Content ─────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabs,
                physics: const BouncingScrollPhysics(),
                children: const [_ApnaPayTab(), _BankTab(), CnicTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  // ── Custom tab bar (segmented control look) ──
  Widget _buildTabBar() {
    const labels = ['ApnaPay', 'Bank', 'CNIC'];
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = _tabs.index == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => _tabs.animateTo(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryNavy : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════
// TAB 1 — ApnaPay
// ═════════════════════════════════════════════════════
class _ApnaPayTab extends StatefulWidget {
  const _ApnaPayTab();

  @override
  State<_ApnaPayTab> createState() => _ApnaPayTabState();
}

class _ApnaPayTabState extends State<_ApnaPayTab> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Form card ──────────────────────────
          FormCard(
            children: [
              label('Mobile number'),
              SizedBox(height: 8.h),
              inputField(
                controller: _ctrl,
                hint: '03XX XXXXXXX',
                icon: Icons.smartphone_rounded,
                suffixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              SizedBox(height: 20.h),
              primaryButton('Continue'),
            ],
          ),
          SizedBox(height: 24.h),

          // ── Recent contacts ────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Recent contacts',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          contactList(
            items: SendMoneyData.recentContacts.map((c) {
              return ContactTile(
                name: c.name,
                subtitle: c.phone,
                avatarBg: c.avatarBg,
                initials: c.initials,
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),

          // ── Footer note ────────────────────────
          footerNote('Free and instant to any ApnaPay wallet'),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════
// TAB 2 — Bank
// ═════════════════════════════════════════════════════
class _BankTab extends StatefulWidget {
  const _BankTab();

  @override
  State<_BankTab> createState() => _BankTabState();
}

class _BankTabState extends State<_BankTab> {
  String? _selectedBank;
  final _ibanCtrl = TextEditingController();

  @override
  void dispose() {
    _ibanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormCard(
            children: [
              label('Bank'),
              SizedBox(height: 8.h),
              _bankDropdown(),
              SizedBox(height: 18.h),
              label('Account number or IBAN'),
              SizedBox(height: 8.h),
              inputField(
                controller: _ibanCtrl,
                hint: 'PK36 MEZN 0001 2345 6789 01...',
                icon: Icons.tag_rounded,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20.h),
              primaryButton('Continue'),
            ],
          ),
          SizedBox(height: 24.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Saved beneficiaries',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          contactList(
            items: SendMoneyData.bankBeneficiaries.map((b) {
              return ContactTile(
                name: b.name,
                subtitle: '${b.bank} · ···· ${b.last4}',
                avatarBg: b.avatarBg,
                initials: b.initials,
                badgeText: b.bank,
                badgeColor: b.bankBadgeColor,
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),

          footerNote('Free instant transfer through 1LINK to 40+ banks'),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _bankDropdown() {
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: _selectedBank == null
              ? AppColors.textLightGrey.withOpacity(0.4)
              : AppColors.primaryNavy.withOpacity(0.5),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 38.r,
            width: 38.r,
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.account_balance_rounded,
              color: AppColors.textGrey,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBank,
                isExpanded: true,
                hint: Text(
                  'Select bank',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textLightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textGrey,
                  size: 22.r,
                ),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                items: SendMoneyData.banks.map((b) {
                  return DropdownMenuItem(value: b, child: Text(b));
                }).toList(),
                onChanged: (v) => setState(() => _selectedBank = v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════
// TAB 3 — CNIC
// ═════════════════════════════════════════════════════

// ═════════════════════════════════════════════════════
// SHARED WIDGETS
// ═════════════════════════════════════════════════════
