// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:monster/main.dart';

void main() {
  testWidgets('Monster Challenge app loads correctly', (final tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app title is present.
    expect(find.text('Monster Challenge'), findsOneWidget);

    // Verify that the monster name is displayed.
    expect(find.text('Aqua-Drache'), findsOneWidget);

    // Verify that the input form is present.
    expect(find.text('Fortschritt eintragen'), findsOneWidget);
  });
}
