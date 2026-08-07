import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:movify/presentation/widgets/app_elevated_button.dart";
import "package:movify/presentation/widgets/app_outlined_button.dart";

void main() {
  group("AppElevatedButton Widget Tests", () {
    testWidgets("renders button text correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              onPressed: () {},
              text: "Valider",
            ),
          ),
        ),
      );

      expect(find.text("Valider"), findsOneWidget);
    });

    testWidgets("triggers onPressed callback when tapped", (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              onPressed: () {
                tapped = true;
              },
              text: "Cliquez ici",
            ),
          ),
        ),
      );

      await tester.tap(find.text("Cliquez ici"));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets("shows CircularProgressIndicator when isLoading is true", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppElevatedButton(
              onPressed: () {},
              text: "Chargement",
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group("AppOutlinedButton Widget Tests", () {
    testWidgets("renders outlined button text correctly", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppOutlinedButton(
              onPressed: () {},
              text: "Annuler",
            ),
          ),
        ),
      );

      expect(find.text("Annuler"), findsOneWidget);
    });
  });
}
