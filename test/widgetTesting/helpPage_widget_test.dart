import 'package:aap_dev_project/models/user.dart';
import 'package:aap_dev_project/pages/help.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HelpPage UI test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HelpPage(
        emailAdress: 'test@example.com',
        user: UserProfile(
          name: "John Moc",
          email: "auroobaparker@gmail.com",
          image: "https://i.imgur.com/BoN9kdC.png",
          mobile: "1234567890",
          medicalHistory: "No medical history",
          adress: "123, ABC Street, XYZ City",
          age: 20,
          cnic: "1234567890123",
        ),
      ),
    ));

    expect(find.text('How Can We Help?'), findsOneWidget);
    expect(find.text('You got a problem?'), findsOneWidget);
    expect(find.text('Your Email'), findsOneWidget);
    expect(find.text('Your Request/Complaint'), findsOneWidget);
    expect(find.text('Send Message'), findsOneWidget);

    // Test tapping the Send Message button
    await tester.tap(find.text('Send Message'));
    await tester.pump();
  });

  testWidgets('HelpPage email and request input test',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: HelpPage(
        emailAdress: 'test@example.com',
        user: UserProfile(
          name: "John Moc",
          email: "auroobaparker@gmail.com",
          image: "https://i.imgur.com/BoN9kdC.png",
          mobile: "1234567890",
          medicalHistory: "No medical history",
          adress: "123, ABC Street, XYZ City",
          age: 20,
          cnic: "1234567890123",
        ), // Replace with an actual UserProfile instance if needed
      ),
    ));

    // Enter text into email and request fields
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(
        find.byType(TextField).last, 'Test request/complaint');

    // Verify that the entered text appears in the respective fields
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('Test request/complaint'), findsOneWidget);
  });
}
