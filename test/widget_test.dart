
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_app/main.dart';

void main() {
  testWidgets('Lab 02 displays student information',
          (WidgetTester tester) async {
        await tester.pumpWidget(const Lab02App());

        // Check student name
        expect(find.text('TSAI KIEN PING'), findsOneWidget);

        // Check student ID
        expect(
          find.text('Student ID: BCS23090012'),
          findsOneWidget,
        );

        // Check personal goal
        expect(
          find.text('"My goal is to be healthy always."'),
          findsOneWidget,
        );

        // Check reusable student profile widget
        expect(find.byType(StudentDetailsSection), findsOneWidget);
      });

  testWidgets('Lab 02 TitleSection displays location details',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TitleSection(
                name: 'Oeschinen Lake',
                location: 'Kandersteg, Switzerland',
                starCount: 41,
              ),
            ),
          ),
        );

        expect(find.text('Oeschinen Lake'), findsOneWidget);
        expect(find.text('Kandersteg, Switzerland'), findsOneWidget);
        expect(find.text('41'), findsOneWidget);
      });
}
