import 'package:apna_pay/constants/app_colors.dart';
import 'package:apna_pay/data/send_money_data.dart';
import 'package:apna_pay/widgets/contact_list.dart';
import 'package:apna_pay/widgets/footer_note.dart';
import 'package:apna_pay/widgets/input_field.dart';
import 'package:apna_pay/widgets/label.dart';
import 'package:apna_pay/widgets/primary_btn.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CnicTab extends StatefulWidget {
  const CnicTab({super.key});

  @override
  State<CnicTab> createState() => _CnicTabState();
}

class _CnicTabState extends State<CnicTab> {
  final _cnicCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();

  @override
  void dispose() {
    _cnicCtrl.dispose();
    _mobileCtrl.dispose();
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
              label("Receiver's CNIC"),
              SizedBox(height: 8.h),
              inputField(
                controller: _cnicCtrl,
                hint: '13-digit CNIC without dashes',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.number,
                maxLength: 13,
              ),
              SizedBox(height: 18.h),
              label("Receiver's mobile"),
              SizedBox(height: 8.h),
              inputField(
                controller: _mobileCtrl,
                hint: 'Pickup code is sent here',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 11,
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
            items: SendMoneyData.cnicBeneficiaries.map((c) {
              return ContactTile(
                name: c.name,
                subtitle: c.cnic,
                avatarBg: c.avatarBg,
                initials: c.initials,
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),

          footerNote(
            'Receiver collects cash at any ApnaPay agent with their CNIC',
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }



  // ── Shared contact tile ───────────────────────────
}

class ContactTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final Color avatarBg;
  final String initials;
  final String? badgeText;
  final Color? badgeColor;

  const ContactTile({
    required this.name,
    required this.subtitle,
    required this.avatarBg,
    required this.initials,
    this.badgeText,
    this.badgeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Avatar with optional badge overlay
          SizedBox(
            height: 52.r,
            width: 52.r,
            child: Stack(
              children: [
                Container(
                  height: 52.r,
                  width: 52.r,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (badgeText != null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor ?? AppColors.green,
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
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
    );
  }
}

class FormCard extends StatelessWidget {
  final List<Widget> children;
  const FormCard({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
