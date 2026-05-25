import 'package:flutter_test/flutter_test.dart';
import 'package:eco_guardianes/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: EcoGuardianesApp()),
    );
    expect(find.byType(EcoGuardianesApp), findsOneWidget);
  });
}
