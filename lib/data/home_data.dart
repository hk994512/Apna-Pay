import '/controllers/nav_controller.dart';
import '/screens/qr_screen.dart';
import '/transfers/apna_transfer.dart';
import '/transfers/bank_transfer.dart';
import '/transfers/mobile_load_screen.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QuickAction {
  final String icon;
  final String label;
  final Color bg;
  final Color iconColor;
  final void Function(BuildContext context) onTap;
  QuickAction({
    required this.icon,
    required this.label,
    required this.bg,
    required this.iconColor,
    required this.onTap,
  });
}

class Transaction {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final Color avatarBg;
  final Color avatarFg;
  final String initials;
  final IconData? icon;

  Transaction({
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

_navTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
}

class HomeData {
  HomeData._();
  static final _quickItems = [
    //1
    {
      'icon': 'assets/transaction.svg',
      'label': 'ApnaPay\nTransfer',
      'bg': AppColors.iconBlue,
      'iconColor': AppColors.blue,
      'onTap': (context) {
        _navTo(context, ApnaPayTransfer());
      },
    },
    //2
    {
      'icon': 'assets/bank-transfer.svg',
      'label': 'Bank\nTransfer',
      'bg': AppColors.iconSky,
      'iconColor': AppColors.blue,
      'onTap': (context) {
        _navTo(context, BankTransfer(tabNumber: 1));
      },
    },
    //3
    {
      'icon': 'assets/vault.svg',
      'label': 'CNIC\nTransfer',
      'bg': AppColors.iconPink,
      'iconColor': AppColors.red,
      'onTap': (context) {
        _navTo(context, BankTransfer(tabNumber: 2));
      },
    },
    //4
    {
      'icon': 'assets/utility-bill-duotone-thin.svg',
      'label': 'Utility\nBills',
      'bg': AppColors.iconOrange,
      'iconColor': AppColors.amber,
      'onTap': (context) => NavController.switchTab(3),
    },
    //5
    {
      'icon': 'assets/device-landline-phone.svg',
      'label': 'Mobile\nLoad',
      'bg': AppColors.iconPurple,
      'iconColor': AppColors.purple,
      'onTap': (context) {
        _navTo(context, MobileLoadScreen());
      },
    },
    //6
    {
      'icon': 'assets/wifi-duotone-bold.svg',
      'label': 'Internet\nBundles',
      'bg': AppColors.iconSky,
      'iconColor': AppColors.blue,
      'onTap': (context) {
        _navTo(context, MobileLoadScreen());
      },
    },
    //7
    {
      'icon': 'assets/qr.svg',
      'label': 'Scan\nQR',
      'bg': AppColors.softGrey,
      'iconColor': AppColors.textDark,
      'onTap': (context) {
        _navTo(context, QrScreen());
      },
    },
    //8
    {
      'icon': 'assets/add-outline.svg',
      'label': 'Add\nCash',
      'bg': AppColors.iconGreen,
      'iconColor': AppColors.green,
      'onTap': (context) {
        _navTo(context, ApnaPayTransfer());
      },
    },
  ];
  static List<QuickAction> quickActions = List.generate(_quickItems.length, (
    q,
  ) {
    final quick = _quickItems[q];
    return QuickAction(
      icon: quick['icon'] as String,
      label: quick['label'] as String,
      bg: quick['bg'] as Color,
      iconColor: quick['iconColor'] as Color,
      onTap: quick['onTap'] as void Function(BuildContext context),
    );
  });
  // static List<QuickAction> quickActions = [
  //   // QuickAction(
  //   //   icon: Icons.swap_horiz_rounded,
  //   //   label: 'ApnaPay\nTransfer',
  //   //   bg: AppColors.iconBlue,
  //   //   iconColor: AppColors.blue,
  //   //   onTap: (context) {
  //   //     _navTo(context, ApnaPayTransfer());
  //   //   },
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.account_balance_rounded,
  //   //   label: 'Bank\nTransfer',
  //   //   bg: AppColors.iconSky,
  //   //   iconColor: AppColors.blue,
  //   //   onTap: (context) {
  //   //     _navTo(context, BankTransfer(tabNumber: 1));
  //   //   },
  //   // ),
  //   // // QuickAction(
  //   // //   icon: Icons.badge_rounded,
  //   // //   label: 'CNIC\nTransfer',
  //   // //   bg: AppColors.iconPink,
  //   // //   iconColor: AppColors.red,
  //   // //   onTap: (context) {
  //   // //     _navTo(context, BankTransfer(tabNumber: 2));
  //   // //   },
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.bolt_rounded,
  //   //   label: 'Utility\nBills',
  //   //   bg: AppColors.iconOrange,
  //   //   iconColor: AppColors.amber,
  //   //   onTap: (context) => NavController.switchTab(3),
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.smartphone_rounded,
  //   //   label: 'Mobile\nLoad',
  //   //   bg: AppColors.iconPurple,
  //   //   iconColor: AppColors.purple,
  //   //   onTap: (context) {
  //   //     _navTo(context, MobileLoadScreen());
  //   //   },
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.wifi_rounded,
  //   //   label: 'Internet\nBundles',
  //   //   bg: AppColors.iconSky,
  //   //   iconColor: AppColors.blue,
  //   //   onTap: (context) {
  //   //     _navTo(context, MobileLoadScreen());
  //   //   },
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.qr_code_scanner_rounded,
  //   //   label: 'Scan\nQR',
  //   //   bg: AppColors.softGrey,
  //   //   iconColor: AppColors.textDark,
  //   //   onTap: (context) {
  //   //     _navTo(context, QrScreen());
  //   //   },
  //   // ),
  //   // QuickAction(
  //   //   icon: Icons.add_card_rounded,
  //   //   label: 'Add\nCash',
  //   //   bg: AppColors.iconGreen,
  //   //   iconColor: AppColors.green,
  //   //   onTap: (context) {
  //   //     _navTo(context, ApnaPayTransfer());
  //   //   },
  //   // ),
  // ];

  static List<Transaction> recentActivity = [
    Transaction(
      title: 'Bilal Ahmed',
      subtitle: 'Received from ApnaPay · 10:30 AM',
      amount: '+ Rs. 5,000',
      isCredit: true,
      avatarBg: AppColors.blue,
      avatarFg: Colors.white,
      initials: 'BA',
    ),
    Transaction(
      title: 'LESCO',
      subtitle: 'Electricity bill · 9:05 AM',
      amount: '– Rs. 3,240',
      isCredit: false,
      avatarBg: AppColors.iconOrange,
      avatarFg: AppColors.amber,
      initials: '',
      icon: Icons.bolt_rounded,
    ),
    Transaction(
      title: 'Jazz Load',
      subtitle: '0300 1234567 · 8:41 AM',
      amount: '– Rs. 500',
      isCredit: false,
      avatarBg: AppColors.iconPurple,
      avatarFg: AppColors.purple,
      initials: '',
      icon: Icons.smartphone_rounded,
    ),
    Transaction(
      title: 'Ayesha Khan',
      subtitle: 'Sent to ApnaPay · 7:12 PM',
      amount: '– Rs. 2,000',
      isCredit: false,
      avatarBg: AppColors.orange,
      avatarFg: Colors.white,
      initials: 'AK',
    ),
    Transaction(
      title: 'Al Makkah Telecom',
      subtitle: 'Cash in at agent · 1:30 PM',
      amount: '+ Rs. 20,000',
      isCredit: true,
      avatarBg: AppColors.iconGreen,
      avatarFg: AppColors.green,
      initials: '',
      icon: Icons.store_rounded,
    ),
  ];
}
