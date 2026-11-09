import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../widgets/numeric_keypad.dart';
import 'root_screen.dart';

/// Which step of the flow we're in.
enum MPinStep { create, confirm }

class MPinScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onSuccess;

  const MPinScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSuccess,
    required this.pHnumber,
  });
  final String pHnumber;
  @override
  State<MPinScreen> createState() => _MPinScreenState();
}

class _MPinScreenState extends State<MPinScreen> {
  static const _pinLength = 4;

  MPinStep _step = MPinStep.create;
  String? _firstPin; // stores the PIN entered in the "create" step

  final List<int> _digits = [];
  bool _busy = false; // true once 4 digits entered (locks keypad)
  bool _error = false; // true on mismatch (shows red state briefly)
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Dynamic title/subtitle per step ─────────────
  String get _title =>
      _step == MPinStep.create ? widget.title : 'Confirm your MPIN';

  String get _subtitle => _step == MPinStep.create
      ? widget.subtitle
      : 'Re-enter the 4-digit MPIN to confirm.';

  // ── Key press ───────────────────────────────────
  void _onKeyTap(int value) {
    if (_busy || _error || _digits.length >= _pinLength) return;

    HapticFeedback.selectionClick();
    setState(() => _digits.add(value));

    if (_digits.length == _pinLength) {
      setState(() => _busy = true);
      HapticFeedback.lightImpact();
      _timer = Timer(const Duration(milliseconds: 300), _handleComplete);
    }
  }

  void _onBackspace() {
    if (_busy || _error || _digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  // ── Called when 4 digits are entered ────────────
  void _handleComplete() {
    if (!mounted) return;
    final entered = _digits.join();

    if (_step == MPinStep.create) {
      // Save and move to confirm step
      _firstPin = entered;
      setState(() {
        _step = MPinStep.confirm;
        _digits.clear();
        _busy = false;
      });
      return;
    }

    // Confirm step
    if (entered == _firstPin) {
      _goToOtp();
    } else {
      // Mismatch → error state, then reset to create step
      setState(() => _error = true);
      HapticFeedback.heavyImpact();

      _timer = Timer(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _error = false;
          _busy = false;
          _digits.clear();
          _step = MPinStep.create;
          _firstPin = null;
        });
      });
    }
  }

  void _goToOtp() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => OtpScreen(
          phoneNumber: '+91 98765 43210', // ← replace with real number
          onVerified: widget.onSuccess,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  // ── Colors ──────────────────────────────────────
  Color get _dotColor {
    if (_error) return Colors.red;
    if (_busy) return AppColors.green;
    return AppColors.primaryNavy;
  }

  Color get _iconBg {
    if (_error) return const Color(0xFFFEE2E2);
    if (_busy) return AppColors.softGreen;
    return const Color(0xFFE8F0FE);
  }

  Color get _iconColor {
    if (_error) return Colors.red;
    if (_busy) return AppColors.green;
    return AppColors.primaryNavy;
  }

  IconData get _icon {
    if (_error) return Icons.close_rounded;
    if (_busy) return Icons.check_rounded;
    return Icons.lock_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // Lock icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 84.r,
              width: 84.r,
              decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  _icon,
                  key: ValueKey('$_busy-$_error'),
                  color: _iconColor,
                  size: 38.r,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                _title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (i) {
                final filled = i < _digits.length;
                return AnimatedScale(
                  scale: filled ? 1.0 : 0.85,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    height: 18.r,
                    width: 18.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? _dotColor : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? _dotColor
                            : AppColors.textLightGrey.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Warning banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFEEFD7),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    height: 32.r,
                    width: 32.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDE0A8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: const Color(0xFFB45309),
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Never share your MPIN. ApnaPay staff will never ask for it.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF7C2D12),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Numeric keypad
            NumericKeypad(onKeyTap: _onKeyTap, onBackspace: _onBackspace),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//                    OTP SCREEN
// ══════════════════════════════════════════════════

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onVerified;

  const OtpScreen({super.key, required this.phoneNumber, this.onVerified});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _otpLength = 6;
  static const _demoOtp = '123456';

  final List<int> _digits = [];
  bool _busy = false;
  bool _error = false;
  Timer? _autoFillTimer;
  Timer? _verifyTimer;

  @override
  void initState() {
    super.initState();

    // After 2 seconds, simulate OTP arriving and auto-fill it.
    _autoFillTimer = Timer(const Duration(seconds: 2), _autoFillOtp);
  }

  @override
  void dispose() {
    _autoFillTimer?.cancel();
    _verifyTimer?.cancel();
    super.dispose();
  }

  void _autoFillOtp() {
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _digits
        ..clear()
        ..addAll(_demoOtp.split('').map(int.parse));
      _busy = true;
    });

    // Small delay so the user sees the filled dots, then verify + navigate.
    _verifyTimer = Timer(const Duration(milliseconds: 500), _onVerified);
  }

  void _onKeyTap(int value) {
    if (_busy || _error || _digits.length >= _otpLength) return;
    HapticFeedback.selectionClick();
    setState(() => _digits.add(value));
    if (_digits.length == _otpLength) {
      setState(() => _busy = true);
      _verifyTimer = Timer(const Duration(milliseconds: 350), _onVerified);
    }
  }

  void _onBackspace() {
    if (_busy || _error || _digits.isEmpty) return;
    setState(() => _digits.removeLast());
  }

  void _onVerified() {
    if (!mounted) return;

    if (widget.onVerified != null) {
      widget.onVerified!();
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const RootScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      (route) => false,
    );
  }

  Color get _dotColor {
    if (_error) return Colors.red;
    if (_busy) return AppColors.green;
    return AppColors.primaryNavy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 84.r,
              width: 84.r,
              decoration: BoxDecoration(
                color: _busy ? AppColors.softGreen : const Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  _busy ? Icons.check_rounded : Icons.sms_outlined,
                  key: ValueKey(_busy),
                  color: _busy ? AppColors.green : AppColors.primaryNavy,
                  size: 38.r,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Verify your number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'We sent a 6-digit code to\n${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // OTP dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_otpLength, (i) {
                final filled = i < _digits.length;
                return AnimatedScale(
                  scale: filled ? 1.0 : 0.85,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    height: 16.r,
                    width: 16.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? _dotColor : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? _dotColor
                            : AppColors.textLightGrey.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Demo hint
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFEEFD7),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    height: 32.r,
                    width: 32.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDE0A8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: const Color(0xFFB45309),
                      size: 18.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Demo: OTP 123456 will auto-fill in a moment.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF7C2D12),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            NumericKeypad(onKeyTap: _onKeyTap, onBackspace: _onBackspace),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
