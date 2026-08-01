import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/extensions/navigation_extensions.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/index.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField, AppElevatedButton;

import "../providers/app_dependencies.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  late GlobalKey<FormState> _formKey;
  User user = User(username: "...", email: "", phone: "");

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _ = await Future.wait([_loadUser()]);
      if (!mounted) return;
      setState(() {});
      _usernameController = TextEditingController(text: user.username);
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: user.phone);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        spacing: AppSpacing.xxl,
        children: [
          AppTopbar(
            title: "Profil",
            actions: [
              IconButton(
                onPressed: () async {
                  final isRemoved = await AppDependencies.of(context)
                      .userRepository
                      .removeUser();
                  if (!isRemoved || !context.mounted) return;
                  context
                    ..showSnackBar("Utilisateur supprimé")
                    ..goToWelcome();
                },
                icon: const Icon(LucideIcons.logOut),
              ),
            ],
            showLeading: isMobile,
            onPop: () => context.goToHome(),
          ),
          CircleAvatar(
            radius: AppSpacing.giga,
            child: Text(
              user.username[0],
              style: const TextStyle(fontSize: 54, fontWeight: .bold),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: AppSpacing.xxl,
                children: [
                  AppTextFormField(
                    isRequired: true,
                    controller: _usernameController,
                    labelText: "Nom complet",
                    textCapitalization: .words,
                    keyboardType: .name,
                    textInputAction: .next,
                  ),
                  AppTextFormField(
                    isRequired: true,
                    controller: _emailController,
                    labelText: "Adresse mail",
                    keyboardType: .emailAddress,
                    textInputAction: .next,
                  ),
                  AppTextFormField(
                    isRequired: true,
                    controller: _phoneController,
                    labelText: "Téléphone",
                    keyboardType: .phone,
                    textInputAction: .done,
                  ),
                ],
              ),
            ),
          ),
          AppElevatedButton(onPressed: submit, text: "VALIDER"),
        ],
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    AppDependencies.of(context).userRepository.saveUser(
      User(
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      ),
    );
  }

  Future<void> _loadUser() async {
    try {
      final myUser = await AppDependencies.of(context).userRepository.getUser();
      user = myUser;
    } catch (e) {
      debugPrint("Erreur chargement user: $e");
    }
  }
}
