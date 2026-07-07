import 'package:flutter_test/flutter_test.dart';

import 'package:mom_time/app.dart';

void main() {
  testWidgets('앱이 정상적으로 뜨고 브랜드명이 보인다', (WidgetTester tester) async {
    await tester.pumpWidget(const MomsTimeApp());
    expect(find.text("Mom's Time"), findsOneWidget);
  });
}
