import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/app_colors.dart';

/// Needs:  flutter pub add qr_flutter
class QrScreen extends StatefulWidget {
  /// 0 = My QR, 1 = Scan
  final int initialTab;
  const QrScreen({super.key, this.initialTab = 0});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen>
    with SingleTickerProviderStateMixin {
  // TODO: replace with real user data
  static const _name = 'M Hamza';
  static const _account = '0300 4125669';
  static const _qrData = 'apnapay://pay?acc=03004125669&name=Ali%20Hassan';

  late int _tab = widget.initialTab;
  bool _flash = false;

  late final AnimationController _scanAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (_tab == 1) _scanAnim.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    super.dispose();
  }

  void _setTab(int i) {
    if (i == _tab) return;
    setState(() => _tab = i);
    if (i == 1) {
      _scanAnim.repeat(reverse: true);
    } else {
      _scanAnim.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _QrHeader(
              tab: _tab,
              onTab: _setTab,
              onBack: () => Navigator.maybePop(context),
            ),
            Transform.translate(
              offset: Offset(0, -24.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  child: _tab == 0
                      ? const _MyQrView(
                          key: ValueKey('my'),
                          name: _name,
                          account: _account,
                          qrData: _qrData,
                        )
                      : _ScanView(
                          key: const ValueKey('scan'),
                          anim: _scanAnim,
                          flashOn: _flash,
                          onFlash: () => setState(() => _flash = !_flash),
                        ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Text(msg),
      ),
    );
}

// ─────────────────────────────────────────────────
// HEADER (back button, title, segmented switch)
// ─────────────────────────────────────────────────
class _QrHeader extends StatelessWidget {
  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback onBack;
  const _QrHeader({
    required this.tab,
    required this.onTab,
    required this.onBack,
  });

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
          Positioned(
            right: -50.w,
            top: -50.h,
            child: Container(
              height: 170.r,
              width: 170.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 46.h),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: onBack,
                      ),
                      Expanded(
                        child: Text(
                          'QR Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 40.r), // balances the back button
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _Segment(
                            icon: Icons.qr_code_2_rounded,
                            label: 'My QR',
                            selected: tab == 0,
                            onTap: () => onTab(0),
                          ),
                        ),
                        Expanded(
                          child: _Segment(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'Scan',
                            selected: tab == 1,
                            onTap: () => onTab(1),
                          ),
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
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 40.r,
          width: 40.r,
          child: Icon(icon, color: Colors.white, size: 18.r),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Segment({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18.r,
                color: selected ? AppColors.primaryNavy : Colors.white70,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.primaryNavy : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SHARED CARD STYLE
// ─────────────────────────────────────────────────
BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(26.r),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 18.r,
      offset: Offset(0, 8.h),
    ),
  ],
);

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: active ? AppColors.primaryNavy : AppColors.softBlue,
          borderRadius: BorderRadius.circular(18.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onTap,
            child: SizedBox(
              height: 52.r,
              width: 52.r,
              child: Icon(
                icon,
                size: 22.r,
                color: active ? Colors.white : AppColors.primaryNavy,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// MY QR TAB
// ─────────────────────────────────────────────────
class _MyQrView extends StatelessWidget {
  final String name;
  final String account;
  final String qrData;
  const _MyQrView({
    super.key,
    required this.name,
    required this.account,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              // Owner row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.amber, width: 2.r),
                    ),
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.orange,
                      child: Text(
                        'AH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
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
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Scan to send me money',
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 13.r,
                          color: AppColors.green,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // QR (sized from available width, never overflows)
              LayoutBuilder(
                builder: (context, c) {
                  final frame = c.maxWidth.clamp(0.0, 300.0).toDouble();
                  final pad = 16.r;
                  final qrSize = frame - pad * 2;
                  return Container(
                    width: frame,
                    padding: EdgeInsets.all(pad),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5FD),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: AppColors.primaryNavy.withOpacity(0.08),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: qrSize - 20.r,
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.white,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.circle,
                              color: Color(0xFF0B3D91),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: Color(0xFF0B3D91),
                            ),
                          ),
                          // Center logo
                          Container(
                            height: 46.r,
                            width: 46.r,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8.r,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(4.r),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1D5FD1),
                                    Color(0xFF0B3D91),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),

              // Account pill (tap to copy)
              Material(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(20.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: account));
                    _snack(context, 'Account number copied');
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Account $account',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.copy_rounded,
                          size: 15.r,
                          color: AppColors.primaryNavy,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Divider(height: 1, color: Colors.black.withOpacity(0.06)),
              SizedBox(height: 16.h),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      // TODO: share_plus -> Share.share(qrData)
                      onTap: () => _snack(context, 'Share coming soon'),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.download_rounded,
                      label: 'Save',
                      // TODO: capture with RepaintBoundary and save to gallery
                      onTap: () => _snack(context, 'Save coming soon'),
                    ),
                  ),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.copy_rounded,
                      label: 'Copy',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: account));
                        _snack(context, 'Account number copied');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        const _InfoTile(
          icon: Icons.shield_outlined,
          text:
              'Anyone can scan this code to send you money. Your balance and PIN stay private.',
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.r, color: AppColors.primaryNavy),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.35,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SCAN TAB
// ─────────────────────────────────────────────────
class _ScanView extends StatelessWidget {
  final AnimationController anim;
  final bool flashOn;
  final VoidCallback onFlash;
  const _ScanView({
    super.key,
    required this.anim,
    required this.flashOn,
    required this.onFlash,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final side = c.maxWidth;
            final height = (side * 1.05).clamp(0.0, 440.0).toDouble();
            final inset = 28.r;

            return ClipRRect(
              borderRadius: BorderRadius.circular(26.r),
              child: SizedBox(
                width: side,
                height: height,
                child: Stack(
                  children: [
                    // Camera placeholder.
                    // TODO: replace with MobileScanner(onDetect: ...) from
                    // package:mobile_scanner for a real camera preview.
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0B1B3A), Color(0xFF10285C)],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: 72.r,
                            color: Colors.white.withOpacity(0.10),
                          ),
                        ),
                      ),
                    ),

                    // Corner brackets
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(inset),
                        child: CustomPaint(
                          painter: _CornerPainter(
                            color: AppColors.amber,
                            stroke: 4.r,
                            length: 30.r,
                            radius: 12.r,
                          ),
                        ),
                      ),
                    ),

                    // Moving scan line
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: inset + 8.r,
                          vertical: inset,
                        ),
                        child: AnimatedBuilder(
                          animation: anim,
                          builder: (context, _) {
                            return Align(
                              alignment: Alignment(0, anim.value * 2 - 1),
                              child: Container(
                                height: 3.r,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.r),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.amber.withOpacity(0),
                                      AppColors.amber,
                                      AppColors.amber.withOpacity(0),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.amber.withOpacity(0.6),
                                      blurRadius: 10.r,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Hint
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      bottom: 12.h,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Align the QR code within the frame',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: flashOn
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  label: flashOn ? 'Flash on' : 'Flash off',
                  active: flashOn,
                  onTap: onFlash, // TODO: controller.toggleTorch()
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  // TODO: image_picker + scanner.analyzeImage
                  onTap: () => _snack(context, 'Gallery scan coming soon'),
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.keyboard_alt_outlined,
                  label: 'Enter code',
                  onTap: () => _snack(context, 'Manual entry coming soon'),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        const _InfoTile(
          icon: Icons.bolt_rounded,
          text: 'Scan a friend\'s or merchant\'s QR code to pay instantly.',
        ),
      ],
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double stroke;
  final double length;
  final double radius;
  _CornerPainter({
    required this.color,
    required this.stroke,
    required this.length,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final r = radius;
    final l = length;

    // top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, l)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(l, 0),
      p,
    );
    // top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - l, 0)
        ..lineTo(w - r, 0)
        ..quadraticBezierTo(w, 0, w, r)
        ..lineTo(w, l),
      p,
    );
    // bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, h - l)
        ..lineTo(0, h - r)
        ..quadraticBezierTo(0, h, r, h)
        ..lineTo(l, h),
      p,
    );
    // bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w - l, h)
        ..lineTo(w - r, h)
        ..quadraticBezierTo(w, h, w, h - r)
        ..lineTo(w, h - l),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color ||
      old.stroke != stroke ||
      old.length != length ||
      old.radius != radius;
}
