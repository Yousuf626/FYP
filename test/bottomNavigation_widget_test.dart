import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aap_dev_project/pages/bottomNavigationBar.dart'; // Update with correct import path
import 'package:aap_dev_project/pages/dashboard.dart';
import 'package:aap_dev_project/pages/shareRecords.dart';

void main() {
  group('BaseMenuBar Tests', () {
    // Test cases will go here
    testWidgets('Finds BottomNavigationBar and its items', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: BaseMenuBar())));

  // Verify the BottomNavigationBar exists
  expect(find.byType(BottomNavigationBar), findsOneWidget);

  // Verify all BottomNavigationBarItem icons
  expect(find.byIcon(Icons.menu), findsOneWidget);
  expect(find.byIcon(Icons.home_outlined), findsOneWidget);
  expect(find.byIcon(Icons.group), findsOneWidget);
});
testWidgets('Taps first BottomNavigationBarItem and opens drawer', (WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(drawer: Drawer(), body: BaseMenuBar())));

  // Tap the first BottomNavigationBarItem
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle(); // Wait for animations

  // Verify that the drawer is opened
  expect(find.byType(Drawer), findsOneWidget);
});
// testWidgets('Taps second BottomNavigationBarItem and navigates to Dashboard', (WidgetTester tester) async {
//   await tester.pumpWidget(MaterialApp(home: Scaffold(body: BaseMenuBar())));

//   // Tap the second BottomNavigationBarItem
//   await tester.tap(find.byIcon(Icons.home_outlined));
//   await tester.pumpAndSettle(); // Wait for animations

//   // Verify that navigation to Dashboard occurred
//   expect(find.byType(DashboardApp), findsOneWidget);
// });
// testWidgets('Taps third BottomNavigationBarItem and navigates to ShareRecords', (WidgetTester tester) async {
//   await tester.pumpWidget(MaterialApp(home: Scaffold(body: BaseMenuBar())));

//   // Tap the third BottomNavigationBarItem
//   await tester.tap(find.byIcon(Icons.group));
//   await tester.pumpAndSettle(); // Wait for animations

//   // Verify that navigation to ShareRecords occurred
//   expect(find.byType(ShareRecords), findsOneWidget);
// });

  });
}
