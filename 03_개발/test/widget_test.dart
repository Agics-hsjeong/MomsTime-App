import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mom_time/app.dart';

void main() {
  testWidgets('스플래시에 브랜드명이 보이고, 잠시 후 온보딩으로 이동한다',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MomsTimeApp()));

    expect(find.text("Mom's Time"), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('다음'), findsOneWidget);
  });
}
