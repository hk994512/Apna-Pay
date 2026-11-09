import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// ── Recent contacts (ApnaPay tab) ──
class RecentContact {
  final String name;
  final String phone;
  final Color avatarBg;
  final String initials;

  RecentContact({
    required this.name,
    required this.phone,
    required this.avatarBg,
    required this.initials,
  });
}

// ── Saved beneficiaries (Bank tab) ──
class BankBeneficiary {
  final String name;
  final String bank;       // "MCB"
  final String last4;      // "2345"
  final Color avatarBg;
  final String initials;
  final Color bankBadgeColor;

  BankBeneficiary({
    required this.name,
    required this.bank,
    required this.last4,
    required this.avatarBg,
    required this.initials,
    required this.bankBadgeColor,
  });
}

// ── Saved beneficiaries (CNIC tab) ──
class CnicBeneficiary {
  final String name;
  final String cnic;       // "35202-1234567-8"
  final Color avatarBg;
  final String initials;

  CnicBeneficiary({
    required this.name,
    required this.cnic,
    required this.avatarBg,
    required this.initials,
  });
}

class SendMoneyData {
  SendMoneyData._();

  static List<RecentContact> recentContacts = [
    RecentContact(
      name: 'Ayesha Khan',
      phone: '0333 9876543',
      avatarBg: AppColors.orange,
      initials: 'AK',
    ),
    RecentContact(
      name: 'Bilal Ahmed',
      phone: '0321 4567890',
      avatarBg: AppColors.blue,
      initials: 'BA',
    ),
    RecentContact(
      name: 'Hamza Sheikh',
      phone: '0345 1122334',
      avatarBg: const Color(0xFFEA580C),
      initials: 'HS',
    ),
    RecentContact(
      name: 'Zainab Raza',
      phone: '0312 7788990',
      avatarBg: const Color(0xFF0EA5E9),
      initials: 'ZR',
    ),
    RecentContact(
      name: 'Imran Qureshi',
      phone: '0301 6655443',
      avatarBg: const Color(0xFF06B6D4),
      initials: 'IQ',
    ),
  ];

  static List<BankBeneficiary> bankBeneficiaries = [
    BankBeneficiary(
      name: 'Usman Tariq',
      bank: 'MCB',
      last4: '2345',
      avatarBg: const Color(0xFFEC4899),
      initials: 'UT',
      bankBadgeColor: const Color(0xFF16A34A),
    ),
    BankBeneficiary(
      name: 'Sana Malik',
      bank: 'MBL',
      last4: '0123',
      avatarBg: const Color(0xFFF59E0B),
      initials: 'SM',
      bankBadgeColor: const Color(0xFF7C3AED),
    ),
    BankBeneficiary(
      name: 'Ahmed Ali',
      bank: 'BOP',
      last4: '4321',
      avatarBg: const Color(0xFF0EA5E9),
      initials: 'AA',
      bankBadgeColor: const Color(0xFF16A34A),
    ),
  ];

  static List<CnicBeneficiary> cnicBeneficiaries = [
    CnicBeneficiary(
      name: 'Fatima Noor',
      cnic: '35202-1234567-8',
      avatarBg: const Color(0xFFEC4899),
      initials: 'FN',
    ),
  ];

  static const List<String> banks = [
    'Meezan Bank',
    'MCB Bank',
    'HBL',
    'UBL',
    'Bank Alfalah',
    'Askari Bank',
    'Bank of Punjab',
    'Faysal Bank',
    'Standard Chartered',
    'Allied Bank',
  ];
}