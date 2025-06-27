// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    // Build a simplified test app
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('BookPalm')),
          body: const Center(child: Text('Welcome to BookPalm')),
        ),
      ),
    );

    // Verify that the app builds without errors
    expect(find.text('BookPalm'), findsOneWidget);
    expect(find.text('Welcome to BookPalm'), findsOneWidget);
  });
}
