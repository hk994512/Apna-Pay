import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileItem {
  final String icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing; // for toggle
  final bool showChevron;

  ProfileItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showChevron = true,
  });
}

class ProfileData {
  ProfileData._();

  static List<ProfileItem> account = [
    ProfileItem(
      icon: 'assets/profile-thin.svg',
      iconBg: AppColors.iconBlue,
      iconColor: AppColors.blue,
      title: 'Personal information',
    ),
    ProfileItem(
      icon: 'assets/card-bold-duotone.svg',
      iconBg: AppColors.iconPurple,
      iconColor: AppColors.purple,
      title: 'Linked cards',
      subtitle: '2 cards',
    ),
    ProfileItem(
      icon: 'assets/bill.svg',
      iconBg: AppColors.iconSky,
      iconColor: AppColors.blue,
      title: 'Saved beneficiaries',
    ),
    ProfileItem(
      icon: 'assets/qr.svg',
      iconBg: AppColors.softGrey,
      iconColor: AppColors.textDark,
      title: 'My QR code',
    ),
  ];

  static List<ProfileItem> security = [
    ProfileItem(
      icon: 'assets/password.svg',
      iconBg: AppColors.iconBlue,
      iconColor: AppColors.blue,
      title: 'Change MPIN',
    ),
    ProfileItem(
      icon: 'assets/fingerprint.svg',
      iconBg: AppColors.iconPink,
      iconColor: AppColors.red,
      title: 'Fingerprint & Face ID',
      showChevron: false,
    ),
    ProfileItem(
      icon: 'assets/workspace-trusted.svg',
      iconBg: AppColors.iconSky,
      iconColor: AppColors.blue,
      title: 'Trusted device',
      subtitle: 'This phone only. Others are signed out.',
    ),
    ProfileItem(
      icon: 'assets/lock-line-duotone.svg',
      iconBg: AppColors.iconOrange,
      iconColor: AppColors.orange,
      title: 'Auto logout',
      subtitle: 'After 3 minutes of inactivity',
    ),
  ];

  static List<ProfileItem> preferences = [
    ProfileItem(
      icon: 'assets/language.svg',
      iconBg: AppColors.iconGreen,
      iconColor: AppColors.green,
      title: 'Language',
      subtitle: 'English · اردو',
    ),
    ProfileItem(
      icon: 'assets/notification.svg',
      iconBg: AppColors.iconPurple,
      iconColor: AppColors.purple,
      title: 'Notifications',
    ),
  ];

  static List<ProfileItem> support = [
    ProfileItem(
      icon: 'assets/wavy-help.svg',
      iconBg: AppColors.iconBlue,
      iconColor: AppColors.blue,
      title: 'Help center',
      subtitle: '24/7 chat and helpline',
    ),
    ProfileItem(
      icon: 'assets/privacy-tip-outline.svg',
      iconBg: AppColors.softGrey,
      iconColor: AppColors.textDark,
      title: 'Terms & privacy',
    ),
  ];
}
