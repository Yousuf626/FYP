import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aap_dev_project/pages/navigation/bottomNavigationBar.dart'; // Update with correct import path

void main() {
  group('BaseMenuBar Tests', () {
    // Test cases will go here
    testWidgets('Finds BottomNavigationBar and its items',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: BaseMenuBar())));

      // Verify the BottomNavigationBar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify all BottomNavigationBarItem icons
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
      expect(find.byIcon(Icons.group), findsOneWidget);
    });
    testWidgets('Taps first BottomNavigationBarItem and opens drawer',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(drawer: const Drawer(), body: BaseMenuBar())));

      // Tap the first BottomNavigationBarItem
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle(); // Wait for animations

      // Verify that the drawer is opened
      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
