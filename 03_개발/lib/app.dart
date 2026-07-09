import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/firebase/push_bootstrap.dart';
import 'core/layout/app_frame.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Mom's Time 앱 루트
class MomsTimeApp extends ConsumerWidget {
  const MomsTimeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: AppLayout.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: "Mom's Time",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
          builder: (context, child) => PushNotificationBootstrap(
            child: AppFrame(child: child ?? const SizedBox()),
          ),
        );
      },
    );
  }
}
