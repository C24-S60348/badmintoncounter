// This is a basic Flutter widget test for Badminton Counter app.

import 'package:flutter_test/flutter_test.dart';

import 'package:badminton_counter/main.dart';

void main() {
  testWidgets('Badminton Counter app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BadmintonCounterApp());

    // Verify that the app loads with Counter page
    expect(find.text('Badminton Counter'), findsOneWidget);
    
    // Verify both players start at 0
    expect(find.text('0'), findsWidgets);
  });
}
