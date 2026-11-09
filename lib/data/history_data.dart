import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HistoryTransaction {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final Color avatarBg;
  final Color avatarFg;
  final String initials;
  final IconData? icon;

  HistoryTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.avatarBg,
    required this.avatarFg,
    required this.initials,
    this.icon,
  });
}

class HistoryGroup {
  final String label;
  final List<HistoryTransaction> items;
  HistoryGroup({required this.label, required this.items});
}

class HistoryData {
  HistoryData._();

  /// Filter chips shown below search bar
  static const List<String> filters = [
    'All',
    'Money in',
    'Money out',
    'Bills',
    'Mobile',
    'Recharge',
    'Bank',
  ];

  /// Transactions grouped by date
  static List<HistoryGroup> groups = [
    HistoryGroup(
      label: 'Today',
      items: [
        HistoryTransaction(
          title: 'Bilal Ahmed',
          subtitle: 'Received from ApnaPay · 10:30 AM',
          amount: '+ Rs. 5,000',
          isCredit: true,
          avatarBg: AppColors.blue,
          avatarFg: Colors.white,
          initials: 'BA',
        ),
        HistoryTransaction(
          title: 'LESCO',
          subtitle: 'Electricity bill · 9:05 AM',
          amount: '– Rs. 3,240',
          isCredit: false,
          avatarBg: AppColors.iconOrange,
          avatarFg: AppColors.amber,
          initials: '',
          icon: Icons.bolt_rounded,
        ),
        HistoryTransaction(
          title: 'Jazz Load',
          subtitle: '0300 1234567 · 8:41 AM',
          amount: '– Rs. 500',
          isCredit: false,
          avatarBg: AppColors.iconPurple,
          avatarFg: AppColors.purple,
          initials: '',
          icon: Icons.smartphone_rounded,
        ),
      ],
    ),
    HistoryGroup(
      label: 'Yesterday',
      items: [
        HistoryTransaction(
          title: 'Ayesha Khan',
          subtitle: 'Sent to ApnaPay · 7:12 PM',
          amount: '– Rs. 2,000',
          isCredit: false,
          avatarBg: AppColors.orange,
          avatarFg: Colors.white,
          initials: 'AK',
        ),
        HistoryTransaction(
          title: 'Al Makkah Telecom',
          subtitle: 'Cash in at agent · 1:30 PM',
          amount: '+ Rs. 20,000',
          isCredit: true,
          avatarBg: AppColors.iconGreen,
          avatarFg: AppColors.green,
          initials: '',
          icon: Icons.store_rounded,
        ),
      ],
    ),
  ];
}
