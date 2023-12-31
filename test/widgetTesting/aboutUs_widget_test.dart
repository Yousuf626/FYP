import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aap_dev_project/pages/drawerOptions/aboutUs.dart';

void main() {
  group('About Us Page Tests', () {
    // Individual test cases will go here
    testWidgets('Finds AboutUsContent widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

      // Verify that AboutUsContent is present
      expect(find.byType(AboutUsContent), findsOneWidget);
    });
    testWidgets('Checks text and layout in AboutUsContent',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

      // Verify text content
      expect(find.text('MedQR Provides'), findsOneWidget);

      // Verify presence of FeatureLine widgets
      expect(find.byType(FeatureLine), findsNWidgets(4));
    });
    testWidgets('Checks each FeatureLine for correct icon and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

      // Helper function to test individual FeatureLine
      void testFeatureLine(String iconPath, String featureText) {
        // Look for an Image widget with the specific AssetImage
        expect(
            find.byWidgetPredicate((Widget widget) =>
                widget is Image &&
                widget.image is AssetImage &&
                (widget.image as AssetImage).assetName == iconPath),
            findsOneWidget);

        // Check for the text
        expect(find.widgetWithText(FeatureLine, featureText), findsOneWidget);
      }

      // Test each FeatureLine
      testFeatureLine('assets/lock.png',
          'Secure storage of medical history, test reports and prescriptions.');
      testFeatureLine('assets/profile.png',
          'Patients can register themselves easily and make their profile.');
      testFeatureLine(
          'assets/calendar.png', 'Customizable medication reminders');
      testFeatureLine(
          'assets/code.png', 'Streamlined doctor access to patient records');
    });
  });
}
