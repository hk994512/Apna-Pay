import 'package:flutter/material.dart';
import '../controllers/nav_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'qr_screen.dart';
import 'bills_screen.dart';
import 'profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    HistoryScreen(),
    QrScreen(),
    BillsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Sync with global controller
    _index = NavController.currentIndex.value;
    NavController.currentIndex.addListener(_onNavChange);
  }

  @override
  void dispose() {
    NavController.currentIndex.removeListener(_onNavChange);
    super.dispose();
  }

  void _onNavChange() {
    final newIndex = NavController.currentIndex.value;
    if (newIndex != _index && mounted) {
      setState(() => _index = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) {
          NavController.switchTab(i); // ← single source of truth
        },
      ),
    );
  }
}
