import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../data/profile_data.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _fingerprintOn = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text('Profile', style: AppTextStyles.h1),
          SizedBox(height: 16.h),

          const _ProfileHeaderCard(),
          SizedBox(height: 16.h),

          const _AccountLimitsCard(),
          SizedBox(height: 20.h),

          const _SectionLabel('Account'),
          _ItemsCard(ProfileData.account),
          SizedBox(height: 20.h),

          const _SectionLabel('Security'),
          _ItemsCard(
            ProfileData.security,
            fingerprintToggle: true,
            fingerprintOn: _fingerprintOn,
            onFingerprintChanged: (v) => setState(() => _fingerprintOn = v),
          ),
          SizedBox(height: 20.h),

          const _SectionLabel('Preferences'),
          _ItemsCard(ProfileData.preferences),
          SizedBox(height: 20.h),

          const _SectionLabel('Support'),
          _ItemsCard(ProfileData.support),
          SizedBox(height: 24.h),

          const _LogoutButton(),
          SizedBox(height: 16.h),

          Center(
            child: Text(
              'ApnaPay 1.0.0 (demo) · APNAPAY PRIVATE LIMITED',
              textAlign: TextAlign.center,
              style: AppTextStyles.small,
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B3D91), Color(0xFF0E4AA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.amber, width: 2.r),
            ),
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.orange,
              child: Text(
                'MH',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'M Hamza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '0300 4125669',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Level 1 · Not verified',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

class _AccountLimitsCard extends StatelessWidget {
  const _AccountLimitsCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.all(18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account limits', style: AppTextStyles.h3),
          SizedBox(height: 18.h),
          const _LimitRow(label: 'Daily', used: 3740, total: 25000),
          SizedBox(height: 16.h),
          const _LimitRow(label: 'Monthly', used: 21580, total: 50000),
          SizedBox(height: 18.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.blue,
                  size: 22.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Verify CNIC to raise limits to Rs. 500,000 a month',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.blue,
                  size: 22.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  final String label;
  final int used;
  final int total;
  const _LimitRow({
    required this.label,
    required this.used,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: AppColors.textGrey, fontSize: 13.sp),
            ),
            Text(
              'Rs. ${_fmt(used)} / Rs. ${_fmt(total)}',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: used / total,
            minHeight: 6.h,
            backgroundColor: AppColors.softGrey,
            valueColor: const AlwaysStoppedAnimation(AppColors.primaryNavy),
          ),
        ),
      ],
    );
  }

  String _fmt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textGrey,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<ProfileItem> items;
  final bool fingerprintToggle;
  final bool fingerprintOn;
  final ValueChanged<bool>? onFingerprintChanged;

  const _ItemsCard(
    this.items, {
    this.fingerprintToggle = false,
    this.fingerprintOn = false,
    this.onFingerprintChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          final isFingerprint =
              fingerprintToggle && item.title == 'Fingerprint & Face ID';

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Row(
                  children: [
                    SvgPicture.asset(item.icon,
                      color: item.iconColor,
                      height: 42,)
                    // IconTile(
                      // icon: item.icon,
                      // bgColor: item.iconBg,
                      // iconColor: item.iconColor,
                      // size: 42,
                    // ),
                    ,SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: AppTextStyles.title),
                          if (item.subtitle != null) ...[
                            SizedBox(height: 2.h),
                            Text(item.subtitle!, style: AppTextStyles.caption),
                          ],
                        ],
                      ),
                    ),
                    if (isFingerprint)
                      Switch.adaptive(
                        value: fingerprintOn,
                        activeColor: AppColors.primaryNavy,
                        onChanged: onFingerprintChanged,
                      )
                    else if (item.showChevron)
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textLightGrey,
                        size: 22.r,
                      ),
                  ],
                ),
              ),
              if (!isLast) Divider(height: 1, indent: 68.w, endIndent: 12.w),
            ],
          );
        }),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE7E7),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.red, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              'Log out',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
