import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/dev/design_showcase_page.dart';

/// Mom's Time 앱 루트
class MomsTimeApp extends StatelessWidget {
  const MomsTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mom's Time",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // TODO(0.4.x): go_router 도입 후 라우팅으로 교체.
      //  화면 흐름: Splash → Onboarding(3) → Login → Stage → Home
      home: const DesignShowcasePage(),
    );
  }
}
