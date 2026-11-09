import 'package:apna_pay/constants/app_assets.dart';
import 'package:apna_pay/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../widgets/onboarding_illustrations.dart';
import '../widgets/app_logo.dart';
import 'phone_number_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  final _slides = const [
    _SlideData(
      title: 'Send money to anyone,\ninstantly',
      subtitle:
          'Transfer to any ApnaPay wallet, any bank in Pakistan, or straight to a CNIC for cash pickup.',
      buttonText: 'Next',
    ),
    _SlideData(
      title: 'Every bill, one tap away',
      subtitle:
          'Pay LESCO, MEPCO, SNGPL, SSGC, PTCL and more. Save your bills and never miss a due date.',
      buttonText: 'Next',
    ),
    _SlideData(
      title: 'Bank-grade security',
      subtitle:
          'MPIN, fingerprint and Face ID, end-to-end encryption and NADRA verified accounts.',
      buttonText: 'Get started',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToPhone();
    }
  }

  void _goToPhone() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PhoneNumberScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: .fromLTRB(20.w, 8.h, 20.w, 0),
              child: Row(
                children: [
                  const AppLogo(),
                  const Spacer(),
                  GestureDetector(
                    onTap: _goToPhone,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Slides ──────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _Slide(
                  data: _slides[i],
                  illustration: _buildIllustration(i),
                ),
              ),
            ),

            // ── Dots ────────────────────────────────
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 8.h,
                    width: active ? 28.w : 8.w,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primaryNavy
                          : AppColors.textLightGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  );
                }),
              ),
            ),

            // ── Next / Get started ──────────────────
            Padding(
              padding: .symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_page < _slides.length - 1) ...[
                        // Icon(Icons.arrow_forward_rounded, size: 20.r),
                        SvgPicture.asset(
                          AppAssets.instance.arrowForward,
                          height: 20.h,
                          color: AppColors.bg,
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        _slides[_page].buttonText,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom "Log in" ─────────────────────
            Padding(
              padding: .symmetric(vertical: 18.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14.sp,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Text(
                      'Log in',
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
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(int i) {
    switch (i) {
      case 0:
        return const SendMoneyIllustration();
      case 1:
        return const EveryBillIllustration();
      default:
        return const SecurityIllustration();
    }
  }
}

class _SlideData {
  final String title;
  final String subtitle;
  final String buttonText;
  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class _Slide extends StatelessWidget {
  final _SlideData data;
  final Widget illustration;
  const _Slide({required this.data, required this.illustration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          illustration,
          SizedBox(height: 20.h),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.25,
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
