import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart'; // Import your main file

void main() {
  testWidgets('DocToPdfConverter UI Test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget( MaterialApp(home: DocToPdfConverter()));

    // Verify the initial state of the app
    expect(find.text('No file selected.'), findsOneWidget);
    expect(find.text('Pick .doc/.docx File'), findsOneWidget);
    expect(find.text('Convert to PDF'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Simulate tapping the "Pick File" button
    await tester.tap(find.text('Pick .doc/.docx File'));
    await tester.pump();

    // Verify the UI after tapping the button
    // (This won't actually pick a file in a test environment; it simulates the button press)
    expect(find.text('No file selected.'), findsOneWidget); // Still no file since FilePicker doesn't work in tests

    // Simulate tapping the "Convert to PDF" button
    await tester.tap(find.text('Convert to PDF'));
    await tester.pump();

    // Check for UI state change
    expect(find.byType(CircularProgressIndicator), findsNothing); // Conversion won't happen in test mode
  });
}
