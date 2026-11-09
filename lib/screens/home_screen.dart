
import 'package:apna_pay/transfers/bank_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../controllers/nav_controller.dart';
import '../data/home_data.dart';
import '../transfers/apna_transfer.dart';
import '../widgets/common_widgets.dart';
import 'qr_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const _HeaderSection(),
          Transform.translate(
            offset: Offset(0, -24.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  const _QuickActionsGrid(),
                  SizedBox(height: 16.h),
                  const _CashbackBanner(),
                  SizedBox(height: 16.h),
                  const _SpentThisMonthCard(),
                  SizedBox(height: 8.h),
                  const SectionHeader(
                    title: 'Recent activity',
                    actionText: 'See all',
                  ),
                  const _RecentActivityList(),
                  SizedBox(height: 24.h),
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
// HEADER
// ─────────────────────────────────────────────────
class _HeaderSection extends StatefulWidget {
  const _HeaderSection();

  @override
  State<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> {
  static const _accountNumber = '0300 4125669';
  bool _hidden = false;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning ☀️';
    if (h < 17) return 'Good afternoon 👋';
    return 'Good evening 🌙';
  }

  void _copyAccount() {
    Clipboard.setData(const ClipboardData(text: _accountNumber));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: const Text('Account number copied'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B3D91), Color(0xFF1558C0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(right: -50.w, top: -50.h, child: _bgCircle(180.r, 0.07)),
          Positioned(left: -40.w, bottom: 20.h, child: _bgCircle(120.r, 0.05)),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 60.h),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top row
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.amber,
                            width: 2.r,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: AppColors.orange,
                          child: Text(
                            'AH',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'M Hamza',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _HeaderIconButton(
                        // icon: Icons.qr_code_scanner_rounded,
                        icon: 'assets/qr.svg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QrScreen(initialTab: 1),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      const _HeaderIconButton(
                        // icon: Icons.notifications_none_rounded,
                        icon: 'assets/alarm.svg',
                        showDot: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Balance card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.14),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Available balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() => _hidden = !_hidden),
                              child: Padding(
                                padding: EdgeInsets.all(2.r),
                                child: Icon(
                                  _hidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white70,
                                  size: 17.r,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.amber,
                                    size: 14.r,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'Level 1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: FittedBox(
                            key: ValueKey(_hidden),
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _hidden ? 'Rs. ••••••' : 'Rs. 48,750',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _copyAccount,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'Account $_accountNumber',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.copy_rounded,
                                color: Colors.white70,
                                size: 14.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickPill(
                                // icon: Icons.add,
                                icon: 'assets/add-outline.svg',
                                label: 'Add Cash',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ApnaPayTransfer(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: _QuickPill(
                                // icon: Icons.send_rounded,
                                icon: 'assets/telegram-outline.svg',
                                label: 'Send',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BankTransfer(tabNumber: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: _QuickPill(
                                icon: 'assets/received.svg',
                                // icon: Icons.call_received_rounded,
                                label: 'Receive',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => QrScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: _QuickPill(
                                // icon: Icons.receipt_rounded,
                                icon: 'assets/bill.svg',
                                label: 'Pay Bills',
                                onTap: () {
                                  NavController.switchTab(3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bgCircle(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final String icon;
  final bool showDot;
  final VoidCallback? onTap;
  const _HeaderIconButton({
    required this.icon,
    this.showDot = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap ?? () {},
        child: SizedBox(
          height: 40.r,
          width: 40.r,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon(icon, color: Colors.white, size: 20.r),
              SvgPicture.asset(icon, color: Colors.white, height: 20.r),
              if (showDot)
                Positioned(
                  right: 10.r,
                  top: 10.r,
                  child: Container(
                    height: 8.r,
                    width: 8.r,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0E4AA8),
                        width: 1.2.r,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickPill extends StatelessWidget {
  final String icon;
  final String label;
  final void Function() onTap;
  const _QuickPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onTap,
            child: SizedBox(
              height: 44.r,
              width: 44.r,
              child: SvgPicture.asset(
                icon,
                height: 20.r,
                color: AppColors.primaryNavy,
              ),
              // Icon(icon, color: AppColors.primaryNavy, size: 22.r),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// QUICK ACTIONS GRID
// ─────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.all(16.r),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: HomeData.quickActions.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 8.w,
          mainAxisExtent: 100.h,
        ),
        itemBuilder: (context, i) {
          final a = HomeData.quickActions[i];
          return InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () => a.onTap(context),
            child: Column(
              children: [
                SvgPicture.asset(a.icon, color: a.iconColor),
                // ,                IconTile(icon: a.icon, bgColor: a.bg, iconColor: a.iconColor),
                SizedBox(height: 6.h),
                Flexible(
                  child: Text(
                    a.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// CASHBACK BANNER (cards size themselves to the screen, next one peeks)
// ─────────────────────────────────────────────────
class _CashbackBanner extends StatelessWidget {
  const _CashbackBanner();

  @override
  Widget build(BuildContext context) {
    final height = 150.h.clamp(144.0, 180.0).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardW = constraints.maxWidth * 0.86;
        return SizedBox(
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              _CashbackCard(
                width: cardW,
                gradient: const [Color(0xFFB45309), Color(0xFFF59E0B)],
                title: '5% cashback on electricity bills',
                subtitle: 'Pay LESCO, MEPCO or IESCO this month',
                buttonText: 'Pay a bill',
                icon: Icons.bolt_rounded,
              ),
              SizedBox(width: 12.w),
              _CashbackCard(
                width: cardW,
                gradient: const [Color(0xFF6D28D9), Color(0xFF7C3AED)],
                title: 'Free transfers',
                subtitle: 'Send money to any bank for free',
                buttonText: 'Send now',
                icon: Icons.send_rounded,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CashbackCard extends StatelessWidget {
  final double width;
  final List<Color> gradient;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;

  const _CashbackCard({
    required this.width,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20.r);
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: gradient[1].withOpacity(0.30),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: InkWell(
              onTap: () {},
              child: Stack(
                children: [
                  Positioned(
                    right: -24.w,
                    top: -24.h,
                    child: Container(
                      height: 100.r,
                      width: 100.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -6.w,
                    bottom: -10.h,
                    child: Icon(
                      icon,
                      size: 96.r,
                      color: Colors.white.withOpacity(0.16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 56.w),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: EdgeInsets.only(right: 56.w),
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 12.sp,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                buttonText,
                                style: TextStyle(
                                  color: gradient[0],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14.r,
                                color: gradient[0],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SPENT THIS MONTH CARD
// ─────────────────────────────────────────────────
class _SpentThisMonthCard extends StatelessWidget {
  const _SpentThisMonthCard();

  static const int _used = 3740;
  static const int _limit = 25000;

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    const bars = [
      _BarData('Mon', 0.15),
      _BarData('Tue', 0.42),
      _BarData('Wed', 0.10),
      _BarData('Thu', 0.15),
      _BarData('Fri', 0.75),
      _BarData('Sat', 0.18),
      _BarData('Sun', 0.40, amount: '8.6k', highlight: true),
    ];

    final progress = _used / _limit;
    final percent = (progress * 100).round();

    return SectionCard(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent this month',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('Rs. 21,580', style: AppTextStyles.h1),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_down_rounded,
                      color: AppColors.blue,
                      size: 14.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '12% less',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const _WeeklyChart(bars: bars),
          SizedBox(height: 14.h),
          Divider(height: 1, color: Colors.black.withOpacity(0.06)),
          SizedBox(height: 14.h),

          // Daily limit
          Row(
            children: [
              Text(
                'Daily limit used',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rs. ${_fmt(_used)}',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' of Rs. ${_fmt(_limit)}',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _LimitBar(progress: progress),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                '$percent% used',
                style: TextStyle(
                  color: AppColors.primaryNavy,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Rs. ${_fmt(_limit - _used)} left today',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LimitBar extends StatelessWidget {
  final double progress;
  const _LimitBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final h = 8.h.clamp(6.0, 10.0).toDouble();
    return LayoutBuilder(
      builder: (context, c) {
        return Stack(
          children: [
            Container(
              height: h,
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(h),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => Container(
                height: h,
                width: c.maxWidth * v,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D5FD1), Color(0xFF0B3D91)],
                  ),
                  borderRadius: BorderRadius.circular(h),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────
// WEEKLY CHART (responsive: every day gets equal width)
// ─────────────────────────────────────────────────
class _BarData {
  final String label;
  final double value; // 0.0 – 1.0
  final String? amount; // small badge shown above the highlighted bar
  final bool highlight;
  const _BarData(this.label, this.value, {this.amount, this.highlight = false});
}

class _WeeklyChart extends StatelessWidget {
  final List<_BarData> bars;
  const _WeeklyChart({required this.bars});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h.clamp(140.0, 190.0).toDouble(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((b) => Expanded(child: _BarItem(data: b))).toList(),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final _BarData data;
  const _BarItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final trackH = 80.h.clamp(70.0, 100.0).toDouble();
    final fillH = (data.value * trackH).clamp(8.0, trackH).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        final barW = (constraints.maxWidth * 0.5).clamp(14.0, 28.w).toDouble();

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (data.highlight && data.amount != null) ...[
              _AmountBadge(text: data.amount!),
              SizedBox(height: 4.h),
            ],
            SizedBox(
              height: trackH,
              width: barW,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(barW),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: fillH),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, h, _) => Container(
                      height: h,
                      decoration: BoxDecoration(
                        gradient: data.highlight
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF1D5FD1), Color(0xFF0B3D91)],
                              )
                            : null,
                        color: data.highlight
                            ? null
                            : AppColors.primaryNavy.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(barW),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            _DayLabel(text: data.label, highlight: data.highlight),
          ],
        );
      },
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  final bool highlight;
  const _DayLabel({required this.text, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primaryNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontSize: 11.sp,
            letterSpacing: 0.2,
            color: highlight ? Colors.white : AppColors.textGrey,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AmountBadge extends StatelessWidget {
  final String text;
  const _AmountBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.softBlue,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryNavy,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// RECENT ACTIVITY
// ─────────────────────────────────────────────────
class _RecentActivityList extends StatelessWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: List.generate(HomeData.recentActivity.length, (i) {
              final t = HomeData.recentActivity[i];
              final isLast = i == HomeData.recentActivity.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
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
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            t.amount,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: t.isCredit
                                  ? AppColors.green
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 76.w, endIndent: 16.w),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
