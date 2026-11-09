import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

// ─────────────────────────────────────────────────
// SAMPLE DATA (replace with real data / API)
// ─────────────────────────────────────────────────
class _CardInfo {
  final String bank;
  final String last4;
  final String holder;
  final bool isVisa;
  final List<Color> colors;
  const _CardInfo({
    required this.bank,
    required this.last4,
    required this.holder,
    required this.isVisa,
    required this.colors,
  });
}

const _cards = [
  _CardInfo(
    bank: 'HBL',
    last4: '4521',
    holder: 'ALI HASSAN',
    isVisa: true,
    colors: [Color(0xFF061F5C), Color(0xFF0050B8)],
  ),
  _CardInfo(
    bank: 'Meezan Bank',
    last4: '8890',
    holder: 'ALI HASSAN',
    isVisa: false,
    colors: [Color(0xFF3B0F6B), Color(0xFF6D28D9)],
  ),
];

const _quickAmounts = [1000, 5000, 10000, 25000];
const _minAmount = 100;
const _maxAmount = 50000;

const _bg = Color(0xFFF4F6FB);

class ApnaPayTransfer extends StatefulWidget {
  const ApnaPayTransfer({super.key});

  @override
  State<ApnaPayTransfer> createState() => _ApnaPayTransferState();
}

class _ApnaPayTransferState extends State<ApnaPayTransfer> {
  int _mode = 0; // 0 = Debit card, 1 = Agent
  int _page = 0; // current carousel page
  int _selected = 0; // selected bank card

  final _amountCtrl = TextEditingController();
  final _focus = FocusNode();
  final _pager = PageController(viewportFraction: 0.86);

  @override
  void initState() {
    super.initState();
    _amountCtrl.addListener(_refresh);
    _focus.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _amountCtrl.removeListener(_refresh);
    _focus.removeListener(_refresh);
    _amountCtrl.dispose();
    _focus.dispose();
    _pager.dispose();
    super.dispose();
  }

  int get _amount => int.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
  bool get _inRange => _amount >= _minAmount && _amount <= _maxAmount;
  bool get _canSubmit => _inRange && (_mode == 1 || _selected >= 0);

  String? get _error {
    if (_amountCtrl.text.isEmpty) return null;
    if (_amount < _minAmount)
      return 'Minimum amount is Rs. ${_fmt(_minAmount)}';
    if (_amount > _maxAmount) {
      return 'Maximum is Rs. ${_fmt(_maxAmount)} per transaction';
    }
    return null;
  }

  void _setAmount(int v) {
    final t = _fmt(v);
    _amountCtrl.value = TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }

  void _submit() {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    if (_mode == 0) {
      final c = _cards[_selected];
      // TODO: call your add-cash API
      _snack(
        context,
        'Adding Rs. ${_fmt(_amount)} from ${c.bank} ••${c.last4}',
      );
    } else {
      _showAgentCode();
    }
  }

  void _showAgentCode() {
    // TODO: get the real code from your backend
    final seed = DateTime.now().millisecondsSinceEpoch % 100000000;
    final raw = seed.toString().padLeft(8, '0');
    final code = '${raw.substring(0, 4)} ${raw.substring(4)}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AgentCodeSheet(code: code, amount: _amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // ── Header ────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: Row(
                  children: [
                    Material(
                      color: Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.maybePop(context),
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
                    ),
                    Expanded(
                      child: Text(
                        'Add Cash',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(width: 44.r),
                  ],
                ),
              ),

              // ── Scrollable body ───────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ModeCard(
                                icon: Icons.credit_card_rounded,
                                title: 'Debit card',
                                subtitle: 'Instant',
                                selected: _mode == 0,
                                onTap: () => setState(() => _mode = 0),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: _ModeCard(
                                icon: Icons.storefront_rounded,
                                title: 'Agent',
                                subtitle: 'Pay cash nearby',
                                selected: _mode == 1,
                                onTap: () => setState(() => _mode = 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Cards carousel (debit card mode)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: _mode == 0
                            ? Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: _carousel(),
                              )
                            : const SizedBox(width: double.infinity),
                      ),

                      SizedBox(height: 22.h),

                      // Amount
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: _amountSection(),
                      ),

                      // Agent extras
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: _mode == 1
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                  20.w,
                                  24.h,
                                  20.w,
                                  0,
                                ),
                                child: const _AgentSection(),
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Pinned bottom bar ─────────────────
              _bottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // Carousel
  // ─────────────────────────────────────────────────
  Widget _carousel() {
    return LayoutBuilder(
      builder: (context, c) {
        final pageW = c.maxWidth * 0.86;
        final cardW = pageW - 12.w;
        final cardH = cardW / 1.6;
        final total = _cards.length + 1;

        return Column(
          children: [
            SizedBox(
              height: cardH + 18.h,
              child: PageView.builder(
                controller: _pager,
                itemCount: total,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (p) => setState(() {
                  _page = p;
                  if (p < _cards.length) _selected = p;
                }),
                itemBuilder: (context, i) {
                  final isLink = i == _cards.length;
                  return AnimatedScale(
                    scale: _page == i ? 1 : 0.94,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 9.h,
                      ),
                      child: isLink
                          ? _LinkCardTile(
                              // TODO: open your "link card" flow
                              onTap: () =>
                                  _snack(context, 'Link card coming soon'),
                            )
                          : _BankCard(
                              info: _cards[i],
                              selected: _selected == i,
                              onTap: () {
                                setState(() => _selected = i);
                                _pager.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(total, (i) {
                final active = _page == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  height: 7.r,
                  width: active ? 22.w : 7.r,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryNavy
                        : AppColors.primaryNavy.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────
  // Amount
  // ─────────────────────────────────────────────────
  Widget _amountSection() {
    final err = _error;
    final focused = _focus.hasFocus;
    Color border = Colors.black.withOpacity(0.06);
    if (err != null) {
      border = AppColors.red;
    } else if (focused) {
      border = AppColors.primaryNavy;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 68.h.clamp(60.0, 78.0).toDouble(),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: border,
              width: focused || err != null ? 1.6 : 1,
            ),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color:
                          (err != null ? AppColors.red : AppColors.primaryNavy)
                              .withOpacity(0.10),
                      blurRadius: 14.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              Text(
                'Rs.',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.primaryNavy,
                  inputFormatters: [_ThousandsFormatter()],
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ),
              ),
              if (_amountCtrl.text.isNotEmpty)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _amountCtrl.clear,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Icon(
                      Icons.cancel_rounded,
                      size: 20.r,
                      color: AppColors.textLightGrey,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Row(
            key: ValueKey(err ?? 'hint'),
            children: [
              SizedBox(width: 4.w),
              Icon(
                err != null
                    ? Icons.error_outline_rounded
                    : Icons.info_outline_rounded,
                size: 15.r,
                color: err != null ? AppColors.red : AppColors.textGrey,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  err ??
                      'Rs. ${_fmt(_minAmount)} to Rs. ${_fmt(_maxAmount)} per transaction',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: err != null ? FontWeight.w600 : FontWeight.w500,
                    color: err != null ? AppColors.red : AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            for (var i = 0; i < _quickAmounts.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: _AmountChip(
                  value: _quickAmounts[i],
                  selected: _amount == _quickAmounts[i],
                  onTap: () => _setAmount(_quickAmounts[i]),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────
  // Bottom bar
  // ─────────────────────────────────────────────────
  Widget _bottomBar() {
    final enabled = _canSubmit;
    final label = _mode == 0
        ? (enabled ? 'Add Rs. ${_fmt(_amount)}' : 'Add cash')
        : 'Generate deposit code';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: enabled ? 1 : 0.45,
            child: Container(
              width: double.infinity,
              height: 56.h.clamp(52.0, 62.0).toDouble(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D5FD1), Color(0xFF0B3D91)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18.r),
                  onTap: enabled ? _submit : null,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _mode == 0
                                ? Icons.add_card_rounded
                                : Icons.qr_code_2_rounded,
                            color: Colors.white,
                            size: 22.r,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _mode == 0
                    ? Icons.lock_outline_rounded
                    : Icons.verified_user_outlined,
                size: 15.r,
                color: AppColors.textGrey,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  _mode == 0
                      ? 'Card details are tokenised, never stored on your phone'
                      : 'The agent confirms the amount before you pay',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────
String _fmt(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
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

class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var d = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (d.length > 6) d = d.substring(0, 6);
    if (d.isEmpty) return const TextEditingValue();
    final t = _fmt(int.parse(d));
    return TextEditingValue(
      text: t,
      selection: TextSelection.collapsed(offset: t.length),
    );
  }
}

// ─────────────────────────────────────────────────
// Mode card (Debit card / Agent)
// ─────────────────────────────────────────────────
class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _ModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22.r);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE8EFFB) : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: selected ? AppColors.primaryNavy : Colors.transparent,
          width: 1.6,
        ),
        boxShadow: selected
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 44.r,
                      width: 44.r,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFC9D9F5)
                            : const Color(0xFFF0F1F5),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        icon,
                        size: 22.r,
                        color: selected
                            ? AppColors.primaryNavy
                            : AppColors.textGrey,
                      ),
                    ),
                    const Spacer(),
                    AnimatedScale(
                      scale: selected ? 1 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 22.r,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  title,
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
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Bank card (designed on a 300x188 canvas and scaled to fit,
// so it looks identical on every screen size)
// ─────────────────────────────────────────────────
class _BankCard extends StatelessWidget {
  final _CardInfo info;
  final bool selected;
  final VoidCallback onTap;
  const _BankCard({
    required this.info,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22.r);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            colors: info.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: selected ? AppColors.orange : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: info.colors[1].withOpacity(selected ? 0.40 : 0.22),
              blurRadius: 18.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 300,
            height: 188,
            child: Stack(
              children: [
                // Decorative circles
                Positioned(right: -50, top: -60, child: _circle(170, 0.07)),
                Positioned(left: -40, bottom: -70, child: _circle(150, 0.06)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              info.bank,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          AnimatedScale(
                            scale: selected ? 1 : 0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            child: Container(
                              height: 26,
                              width: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Chip
                      Container(
                        height: 30,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF1D78A), Color(0xFFD9B04D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.18),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '••••   ••••   ••••   ${info.last4}',
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              info.holder,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          _NetworkMark(isVisa: info.isVisa),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(opacity),
    ),
  );
}

class _NetworkMark extends StatelessWidget {
  final bool isVisa;
  const _NetworkMark({required this.isVisa});

  @override
  Widget build(BuildContext context) {
    if (isVisa) {
      return const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      );
    }
    // Two overlapping circles (Mastercard-style)
    return SizedBox(
      height: 26,
      width: 42,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              height: 26,
              width: 26,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// "Link card" tile (dashed border)
// ─────────────────────────────────────────────────
class _LinkCardTile extends StatelessWidget {
  final VoidCallback onTap;
  const _LinkCardTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(
        color: AppColors.primaryNavy.withOpacity(0.35),
        radius: 22.r,
      ),
      child: Material(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(22.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(22.r),
          onTap: onTap,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 46.r,
                      width: 46.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softBlue,
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 28.r,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Link card',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Add a debit card',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 1.6;
    const dash = 7.0;
    const gap = 5.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(stroke / 2);

    final path = Path()..addRRect(rrect);
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) =>
      old.color != color || old.radius != radius;
}

// ─────────────────────────────────────────────────
// Quick amount chip
// ─────────────────────────────────────────────────
class _AmountChip extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;
  const _AmountChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(30.r);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 46.h.clamp(42.0, 52.0).toDouble(),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryNavy : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: selected
              ? AppColors.primaryNavy
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _fmt(value),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Agent mode: how it works + nearby agents
// ─────────────────────────────────────────────────
class _AgentSection extends StatelessWidget {
  const _AgentSection();

  // TODO: replace with real agents from your backend / location
  static const _agents = [
    ('Ahmad General Store', '350 m away', 'Open'),
    ('Khan Mobile Shop', '700 m away', 'Open'),
    ('Al-Madina Traders', '1.2 km away', 'Closes 9 PM'),
  ];

  static const _steps = [
    ('Enter an amount', 'Then tap "Generate deposit code".'),
    ('Visit any agent', 'Show them your deposit code.'),
    ('Pay the cash', 'Your balance updates after the agent confirms.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How it works',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: _cardDeco(),
          child: Column(
            children: [
              for (var i = 0; i < _steps.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30.r,
                      width: 30.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF1D5FD1), Color(0xFF0B3D91)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _steps[i].$1,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _steps[i].$2,
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.3,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (i != _steps.length - 1) SizedBox(height: 14.h),
              ],
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Nearby agents',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Text(
              'See map',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        for (final a in _agents)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _AgentTile(name: a.$1, distance: a.$2, status: a.$3),
          ),
      ],
    );
  }
}

BoxDecoration _cardDeco() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.r),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.045),
      blurRadius: 12.r,
      offset: Offset(0, 5.h),
    ),
  ],
);

class _AgentTile extends StatelessWidget {
  final String name;
  final String distance;
  final String status;
  const _AgentTile({
    required this.name,
    required this.distance,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final open = status == 'Open';
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: _cardDeco(),
      child: Row(
        children: [
          Container(
            height: 46.r,
            width: 46.r,
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.storefront_rounded,
              size: 22.r,
              color: AppColors.primaryNavy,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 13.r,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(width: 3.w),
                    Flexible(
                      child: Text(
                        distance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: open ? AppColors.softGreen : const Color(0xFFFFF3DC),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: open ? AppColors.green : const Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Agent deposit code bottom sheet
// ─────────────────────────────────────────────────
class _AgentCodeSheet extends StatelessWidget {
  final String code;
  final int amount;
  const _AgentCodeSheet({required this.code, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Show this code to the agent',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Deposit amount: Rs. ${_fmt(amount)}',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textGrey),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 22.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B3D91), Color(0xFF1558C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  code,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      _snack(context, 'Code copied');
                    },
                    icon: Icon(Icons.copy_rounded, size: 18.r),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryNavy,
                      side: BorderSide(
                        color: AppColors.primaryNavy.withOpacity(0.3),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
