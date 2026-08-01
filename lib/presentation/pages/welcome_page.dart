import "package:flutter/material.dart";
import "package:movify/core/extensions/index.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/data/services/local_storage_service.dart";
import "package:movify/presentation/widgets/app_elevated_button.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold, AppTextFormField;

import "../providers/app_dependencies.dart";

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasName = await SharedPrefsService.hasName;
      if (hasName && mounted) context.goToHome();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.outline, width: 2),
    );
    final isMobile = context.isMobile;
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          RichText(
            textAlign: .center,
            text: TextSpan(
              text: "Bienvenue sur\n",
              style: textTheme.headlineLarge,
              children: [
                TextSpan(
                  text: "MOVIFY",
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          AppTextFormField(
            controller: _nameController,
            isRequired: true,
            filled: false,
            autoFocus: true,
            padding: isMobile
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: AppSpacing.mega),
            textAlign: .center,
            keyboardType: .name,
            textCapitalization: .words,
            hintText: "Votre nom",
            hintStyle: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            onEditingComplete: submit,
            border: border,
            focusBorder: border,
          ),

          if (!isMobile)
            AppElevatedButton(
              onPressed: submit,
              buttonMaxSize: Size(
                context.screenWidth * 0.4,
                AppSpacing.buttonHeightLg,
              ),
              text: "VALIDER",
            ),
        ],
      ),
    );
  }

  Future<void> submit() async {
    final name = _nameController.text;
    if (name.isEmpty) return;
    final appDepency = AppDependencies.of(context);
    await appDepency.userRepository.updateUser(username: name);
    if (!mounted) return;
    context.goToHome();
  }
}
