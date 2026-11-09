import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

import '../screens/electricity_screen.dart';
import 'company_data.dart';

class BillCategory {
  final String icon;
  final String label;
  final Color bg;
  final Color fg;
  final void Function(BuildContext context) onPress;

  BillCategory({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onPress,
  });
}

class SavedBill {
  final String provider; // "LESCO", "SNGPL"
  final Color providerBg;
  final Color providerFg;
  final String title; // "Home electricity"
  final String consumerId; // "9123"
  final String amount; // "Rs. 4,870"
  final String? dueText; // "Due in 2 days" — null = no badge
  final bool isOverdue;

  SavedBill({
    required this.provider,
    required this.providerBg,
    required this.providerFg,
    required this.title,
    required this.consumerId,
    required this.amount,
    this.dueText,
    this.isOverdue = false,
  });
}

class BillsData {
  BillsData._();

  static const String totalDue = 'Rs. 9,029';
  static const int savedCount = 3;

  // ── Helper: category list se push karo ─────────
  static void _openCompanyList(BuildContext context, CompanyCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CompanyListScreen(category: category)),
    );
  }

  static List<BillCategory> categories = [
    BillCategory(
      icon: 'assets/electricity-outline.svg',
      label: 'Electricity',
      bg: AppColors.iconOrange,
      fg: AppColors.amber,
      onPress: (context) => _openCompanyList(context, CompanyData.electricity),
    ),
    BillCategory(
      icon: 'assets/gas-pump.svg',
      label: 'Gas',
      bg: const Color(0xFFFBE9E7),
      fg: const Color(0xFFE64A19),
      onPress: (context) => _openCompanyList(context, CompanyData.gas),
    ),
    BillCategory(
      icon: 'assets/water-outline.svg',
      label: 'Water',
      bg: const Color(0xFFE1F5FE),
      fg: const Color(0xFF039BE5),
      onPress: (context) => _openCompanyList(context, CompanyData.water),
    ),
    BillCategory(
      icon: 'assets/wifi-duotone-bold.svg',
      label: 'Internet',
      bg: AppColors.iconPurple,
      fg: AppColors.purple,
      onPress: (context) => _openCompanyList(context, CompanyData.internet),
    ),
    BillCategory(
      icon: 'assets/device-landline-phone.svg',
      label: 'Landline',
      bg: AppColors.iconGreen,
      fg: AppColors.green,
      onPress: (context) => _openCompanyList(context, CompanyData.landline),
    ),
    BillCategory(
      icon: 'assets/task-soon-16.svg',
      label: 'More soon',
      bg: AppColors.softGrey,
      fg: AppColors.textGrey,
      onPress: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Education fees and government challans are coming soon',
            ),
          ),
        );
      },
    ),
  ];

  static List<SavedBill> savedBills = [
    SavedBill(
      provider: 'LESCO',
      providerBg: const Color(0xFFE8A020),
      providerFg: Colors.white,
      title: 'Home electricity',
      consumerId: '9123',
      amount: 'Rs. 4,870',
      dueText: 'Due in 2 days',
      isOverdue: true,
    ),
    SavedBill(
      provider: 'SNGPL',
      providerBg: const Color(0xFFF4511E),
      providerFg: Colors.white,
      title: 'Home gas',
      consumerId: '8901',
      amount: 'Rs. 1,260',
      dueText: 'Due in 5 days',
      isOverdue: false,
    ),
    SavedBill(
      provider: 'PTCL',
      providerBg: const Color(0xFF16A34A),
      providerFg: Colors.white,
      title: 'Home internet',
      consumerId: '5540',
      amount: 'Rs. 2,899',
      dueText: 'Due in 8 days',
      isOverdue: false,
    ),
  ];
}
