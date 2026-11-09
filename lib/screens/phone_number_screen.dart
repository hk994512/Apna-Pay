import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import 'mpin_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
    _focus.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _focus.removeListener(_refresh);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Digits only (the field shows "0300 1234567" with a space).
  String get _digits => _controller.text.replaceAll(RegExp(r'\D'), '');

  bool get _isValid => RegExp(r'^03\d{9}$').hasMatch(_digits);

  String? get _error {
    final d = _digits;
    if (d.isEmpty) return null;
    if (d.length == 1 && d != '0') return 'Number must start with 03';
    if (d.length >= 2 && !d.startsWith('03')) {
      return 'Number must start with 03';
    }
    return null;
  }

  void _onSend() {
    if (!_isValid) return;
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MPinScreen(
          pHnumber: _controller.text.trim(),
          title: 'Create a 4-digit MPIN',
          subtitle: 'You will use it to log in and approve every payment',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Soft decorative background circles
          Positioned(
            top: -90.h,
            right: -70.w,
            child: Container(
              height: 240.r,
              width: 240.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryNavy.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 90.h,
            left: -60.w,
            child: Container(
              height: 120.r,
              width: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.amber.withOpacity(0.07),
              ),
            ),
          ),

          SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  // ── Scrollable content ────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          _circleBackButton(),
                          SizedBox(height: 26.h),

                          // Icon badge
                          Container(
                            height: 64.r,
                            width: 64.r,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF1D5FD1), Color(0xFF0B3D91)],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryNavy.withOpacity(
                                    0.28,
                                  ),
                                  blurRadius: 16.r,
                                  offset: Offset(0, 8.h),
                                ),
                              ],
                            ),

                            child: Icon(
                              Icons.phone_iphone_rounded,
                              color: Colors.white,
                              size: 30.r,
                            ),
                          ),
                          SizedBox(height: 22.h),

                          // Title
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                height: 1.2,
                              ),
                              children: const [
                                TextSpan(text: 'Enter your\n'),
                                TextSpan(
                                  text: 'mobile number',
                                  style: TextStyle(
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Subtitle
                          Text(
                            "We will send a 6-digit code by SMS to verify it's you.",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textGrey,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // Label
                          Text(
                            'Mobile number',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          _phoneInput(),
                          SizedBox(height: 8.h),
                          _helperRow(),
                          SizedBox(height: 18.h),

                          // Info tile
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softBlue,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 18.r,
                                  color: AppColors.primaryNavy,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    'Your number is used only to secure your account.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      height: 1.35,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),

                  // ── Pinned bottom section ─────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              color: AppColors.textGrey,
                              height: 1.5,
                            ),
                            children: const [
                              TextSpan(
                                text: "By continuing you agree to ApnaPay's ",
                              ),
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: AppColors.primaryNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primaryNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 14.h),
                        _sendButton(),
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

  // ─────────────────────────────────────────────────
  // Widgets
  // ─────────────────────────────────────────────────
  Widget _circleBackButton() {
    return Material(
      color: Colors.white,
      shape: CircleBorder(
        side: BorderSide(color: AppColors.softGrey, width: 1),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.pop(context),
        child: SizedBox(
          height: 44.r,
          width: 44.r,
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textDark,
            size: 26.r,
          ),
        ),
      ),
    );
  }

  Widget _phoneInput() {
    final hasError = _error != null;
    final focused = _focus.hasFocus;

    Color borderColor;
    if (hasError) {
      borderColor = AppColors.red;
    } else if (_isValid) {
      borderColor = AppColors.green;
    } else if (focused) {
      borderColor = AppColors.primaryNavy;
    } else {
      borderColor = Colors.transparent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 60.h.clamp(56.0, 68.0).toDouble(),
      decoration: BoxDecoration(
        color: focused ? Colors.white : const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.4),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: (hasError ? AppColors.red : AppColors.primaryNavy)
                      .withOpacity(0.10),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ]
            : const [],
      ),
      child: Row(
        children: [
          // Country
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇵🇰', style: TextStyle(fontSize: 22.sp)),
                SizedBox(width: 6.w),
                Text(
                  'PK',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 28.h,
            width: 1,
            color: AppColors.textLightGrey.withOpacity(0.4),
          ),
          SizedBox(width: 12.w),

          // Input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSend(),
              cursorColor: AppColors.primaryNavy,
              inputFormatters: [_PhoneFormatter()],
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '0300 1234567',
                hintStyle: TextStyle(
                  fontSize: 17.sp,
                  color: AppColors.textLightGrey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Trailing: valid check / clear
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isValid
                ? Padding(
                    key: const ValueKey('ok'),
                    padding: EdgeInsets.only(right: 14.w, left: 6.w),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.green,
                      size: 22.r,
                    ),
                  )
                : _controller.text.isNotEmpty
                ? GestureDetector(
                    key: const ValueKey('clear'),
                    behavior: HitTestBehavior.opaque,
                    onTap: _controller.clear,
                    child: Padding(
                      padding: EdgeInsets.only(right: 14.w, left: 6.w),
                      child: Icon(
                        Icons.cancel_rounded,
                        color: AppColors.textLightGrey,
                        size: 20.r,
                      ),
                    ),
                  )
                : SizedBox(key: const ValueKey('none'), width: 14.w),
          ),
        ],
      ),
    );
  }

  Widget _helperRow() {
    final err = _error;
    return Row(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: err != null
                ? Row(
                    key: const ValueKey('err'),
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 15.r,
                        color: AppColors.red,
                      ),
                      SizedBox(width: 5.w),
                      Flexible(
                        child: Text(
                          err,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Format: 03XX XXXXXXX',
                    key: const ValueKey('hint'),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
          ),
        ),
        Text(
          '${_digits.length}/11',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: _isValid ? AppColors.green : AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _sendButton() {
    final enabled = _isValid;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      height: 56.h.clamp(52.0, 62.0).toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.primaryNavy.withOpacity(0.30),
                  blurRadius: 16.r,
                  offset: Offset(0, 8.h),
                ),
              ]
            : const [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? _onSend : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primaryNavy.withOpacity(0.35),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Send code',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_rounded, size: 20.r),
          ],
        ),
      ),
    );
  }
}

/// Keeps digits only, max 11, and shows them as "0300 1234567".
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 11) d = d.substring(0, 11);

    final buf = StringBuffer();
    for (var i = 0; i < d.length; i++) {
      if (i == 4) buf.write(' ');
      buf.write(d[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
