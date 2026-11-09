import 'package:flutter/material.dart';

class Company {
  final String code; // "LESCO"
  final String fullName; // "Lahore Electric Supply"
  final Color brandColor; // brand tile bg

  Company({
    required this.code,
    required this.fullName,
    required this.brandColor,
  });
}

class CompanyCategory {
  final String title; // "Electricity bills"
  final String searchHint; // "Search electricity companies"
  final List<Company> companies;

  CompanyCategory({
    required this.title,
    required this.searchHint,
    required this.companies,
  });
}

class CompanyData {
  CompanyData._();

  // ── Electricity ────────────────────────────────
  static final electricity = CompanyCategory(
    title: 'Electricity bills',
    searchHint: 'Search electricity companies',
    companies: [
      Company(
        code: 'LESCO',
        fullName: 'Lahore Electric Supply',
        brandColor: const Color(0xFFE8A020),
      ),
      Company(
        code: 'MEPCO',
        fullName: 'Multan Electric Power',
        brandColor: const Color(0xFF2563EB),
      ),
      Company(
        code: 'IESCO',
        fullName: 'Islamabad Electric Supply',
        brandColor: const Color(0xFF16A34A),
      ),
      Company(
        code: 'FESCO',
        fullName: 'Faisalabad Electric Supply',
        brandColor: const Color(0xFFEA580C),
      ),
      Company(
        code: 'GEPCO',
        fullName: 'Gujranwala Electric Power',
        brandColor: const Color(0xFF7C3AED),
      ),
      Company(
        code: 'KE',
        fullName: 'K-Electric',
        brandColor: const Color(0xFFDC2626),
      ),
      Company(
        code: 'PESCO',
        fullName: 'Peshawar Electric Supply',
        brandColor: const Color(0xFF15803D),
      ),
      Company(
        code: 'HESCO',
        fullName: 'Hyderabad Electric Supply',
        brandColor: const Color(0xFF1E88E5),
      ),
    ],
  );

  // ── Gas ────────────────────────────────────────
  static final gas = CompanyCategory(
    title: 'Gas bills',
    searchHint: 'Search gas companies',
    companies: [
      Company(
        code: 'SNGPL',
        fullName: 'Sui Northern Gas',
        brandColor: const Color(0xFFEA580C),
      ),
      Company(
        code: 'SSGC',
        fullName: 'Sui Southern Gas',
        brandColor: const Color(0xFFEA580C),
      ),
    ],
  );

  // ── Water ──────────────────────────────────────
  static final water = CompanyCategory(
    title: 'Water bills',
    searchHint: 'Search water companies',
    companies: [
      Company(
        code: 'WASA',
        fullName: 'WASA Lahore',
        brandColor: const Color(0xFF0E7490),
      ),
      Company(
        code: 'KWSC',
        fullName: 'Karachi Water & Sewerage',
        brandColor: const Color(0xFF0E7490),
      ),
    ],
  );

  // ── Internet ───────────────────────────────────
  static final internet = CompanyCategory(
    title: 'Internet bills',
    searchHint: 'Search internet companies',
    companies: [
      Company(
        code: 'PTCL',
        fullName: 'PTCL Broadband',
        brandColor: const Color(0xFF16A34A),
      ),
      Company(
        code: 'NAYA',
        fullName: 'Nayatel',
        brandColor: const Color(0xFF7C3AED),
      ),
      Company(
        code: 'STORM',
        fullName: 'StormFiber',
        brandColor: const Color(0xFF2563EB),
      ),
      Company(
        code: 'WTN',
        fullName: 'Wateen',
        brandColor: const Color(0xFFBE185D),
      ),
    ],
  );

  // ── Landline ───────────────────────────────────
  static final landline = CompanyCategory(
    title: 'Landline bills',
    searchHint: 'Search landline companies',
    companies: [
      Company(
        code: 'PTCL',
        fullName: 'PTCL Landline',
        brandColor: const Color(0xFF16A34A),
      ),
    ],
  );
}
