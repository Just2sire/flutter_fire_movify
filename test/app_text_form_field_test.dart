import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:movify/presentation/widgets/app_text_form_field.dart";

void main() {
  group("AppTextFormField Widget Tests", () {
    testWidgets("renders labelText and accepts text input", (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              labelText: "Nom complet",
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text("Nom complet"), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), "John Doe");
      expect(controller.text, equals("John Doe"));
    });

    testWidgets("shows validation error message when isRequired is true and field is empty",
        (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: const AppTextFormField(
                labelText: "Email",
                isRequired: true,
              ),
            ),
          ),
        ),
      );

      // Trigger validation
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text("L'attribut Email est requis."), findsOneWidget);
    });
  });
}
