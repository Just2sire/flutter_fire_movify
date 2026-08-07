import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:movify/presentation/widgets/app_topbar.dart";

void main() {
  testWidgets("AppTopbar renders title and actions correctly", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppTopbar(title: "Films Populaires", showLeading: false),
        ),
      ),
    );

    expect(find.text("Films Populaires"), findsOneWidget);
  });
}
