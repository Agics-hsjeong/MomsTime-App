import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../ai_care/presentation/ai_care_page.dart';
import '../../calendar/presentation/calendar_page.dart';
import '../../home/presentation/home_page.dart';
import '../../medication/presentation/medication_page.dart';
import '../../mypage/presentation/my_page.dart';

/// 메인 탭 셸 — 퍼블리싱 `.app--has-nav` + `.bottom-nav`.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  late int _tab = widget.initialTab;

  void goToTab(int index) {
    if (index < 0 || index >= 5) return;
    setState(() => _tab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _tab,
        children: const [
          HomePage(),
          MedicationPage(),
          CalendarPage(),
          AiCarePage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

/// 하위 탭에서 MainShell 탭 전환.
void switchMainTab(BuildContext context, int index) {
  final shell = context.findAncestorStateOfType<MainShellState>();
  shell?.goToTab(index);
}
