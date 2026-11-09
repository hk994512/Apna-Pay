import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import '../widgets/app_logo.dart';
import 'root_screen.dart';
import 'mpin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _mpinCtrl = TextEditingController();

  bool _obscureMpin = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _mpinCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _phoneCtrl.text.trim().length == 11 && _mpinCtrl.text.trim().length >= 4;

  void _onLogin() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO: real auth call
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RootScreen()),
      (route) => false,
    );
  }

  void _onForgotMpin() {
    // Navigate to MPIN reset flow
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MPinScreen(
          pHnumber: _phoneCtrl.text.trim(),
          title: 'Reset your MPIN',
          subtitle: 'Create a new 4-digit MPIN for your account',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              onChanged: () => setState(() {}),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // ── Logo ────────────────────────
                  const AppLogo(),
                  SizedBox(height: 40.h),

                  // ── Title ───────────────────────
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Log in to your ApnaPay account',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textGrey,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 36.h),

                  // ── Phone label ─────────────────
                  _fieldLabel('Mobile number'),
                  SizedBox(height: 8.h),
                  _phoneField(),
                  SizedBox(height: 20.h),

                  // ── MPIN label + forgot ─────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _fieldLabel('MPIN'),
                      GestureDetector(
                        onTap: _onForgotMpin,
                        child: Text(
                          'Forgot MPIN?',
                          style: TextStyle(
                            color: AppColors.primaryNavy,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _mpinField(),
                  SizedBox(height: 16.h),

                  // ── Remember me ─────────────────
                  _rememberRow(),
                  SizedBox(height: 28.h),

                  // ── Login button ────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _onLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.primaryNavy
                            .withOpacity(0.35),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Divider with "or" ───────────
                  _orDivider(),
                  SizedBox(height: 24.h),

                  // ── Biometric login ─────────────
                  _biometricButton(),
                  SizedBox(height: 36.h),

                  // ── Sign up link ────────────────
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const RootScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: AppColors.primaryNavy,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Field label
  // ─────────────────────────────────────────────
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Phone input
  // ─────────────────────────────────────────────
  Widget _phoneField() {
    return _InputShell(
      child: Row(
        children: [
          // Country flag
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0B6B3A),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text('🇵🇰', style: TextStyle(fontSize: 18.sp)),
            ),
          ),
          Container(
            height: 30.h,
            width: 1,
            color: AppColors.textLightGrey.withOpacity(0.4),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0300 1234567',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textLightGrey,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (!RegExp(r'^03\d{9}$').hasMatch(v.trim())) {
                  return 'Enter a valid number (03XX XXXXXXX)';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MPIN input
  // ─────────────────────────────────────────────
  Widget _mpinField() {
    return _InputShell(
      child: Row(
        children: [
          SizedBox(width: 14.w),
          Icon(
            Icons.lock_outline_rounded,
            color: AppColors.textGrey,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: _mpinCtrl,
              keyboardType: TextInputType.number,
              obscureText: _obscureMpin,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '••••',
                hintStyle: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textLightGrey,
                  letterSpacing: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please enter your MPIN';
                }
                if (v.length < 4) {
                  return 'MPIN must be 4 digits';
                }
                return null;
              },
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _obscureMpin = !_obscureMpin),
            icon: Icon(
              _obscureMpin
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.textGrey,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Remember me row
  // ─────────────────────────────────────────────
  Widget _rememberRow() {
    return GestureDetector(
      onTap: () => setState(() => _rememberMe = !_rememberMe),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 20.r,
            width: 20.r,
            decoration: BoxDecoration(
              color: _rememberMe ? AppColors.primaryNavy : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: _rememberMe
                    ? AppColors.primaryNavy
                    : AppColors.textLightGrey,
                width: 1.5,
              ),
            ),
            child: _rememberMe
                ? Icon(Icons.check_rounded, color: Colors.white, size: 14.r)
                : null,
          ),
          SizedBox(width: 10.w),
          Text(
            'Remember me on this device',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // "or continue with" divider
  // ─────────────────────────────────────────────
  Widget _orDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.textLightGrey.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.textLightGrey.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Biometric button
  // ─────────────────────────────────────────────
  Widget _biometricButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: OutlinedButton(
        onPressed: () {
          // TODO: local_auth
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const RootScreen()),
            (route) => false,
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.primaryNavy.withOpacity(0.3),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint_rounded,
              color: AppColors.primaryNavy,
              size: 22.r,
            ),
            SizedBox(width: 10.w),
            Text(
              'Use fingerprint or Face ID',
              style: TextStyle(
                color: AppColors.primaryNavy,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Shared shell for input fields
// ─────────────────────────────────────────────────
class _InputShell extends StatelessWidget {
  final Widget child;
  const _InputShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}
