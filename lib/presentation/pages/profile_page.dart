import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/extensions/navigation_extensions.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/index.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppElevatedButton, AppOutlinedButton, AppScaffold, AppTextFormField, AppTopbar;

import "../providers/app_dependencies.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  User user = User(username: "Utilisateur", email: "", phone: "");
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUser();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final myUser = await AppDependencies.of(context).userRepository.getUser();
      if (!mounted) return;
      setState(() {
        user = myUser;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur chargement user: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    final updatedUser = User(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    AppDependencies.of(context).userRepository.saveUser(updatedUser);
    setState(() => user = updatedUser);
    context.showSnackBar("Profil sauvegardé !");
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final initial = user.username.isNotEmpty ? user.username[0].toUpperCase() : "U";

    return AppScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        spacing: AppSpacing.md,
        children: [
          AppTopbar(
            title: "Profil Utilisateur",
            actions: [
              IconButton(
                tooltip: "Déconnexion / Supprimer",
                onPressed: () async {
                  final isRemoved = await AppDependencies.of(context)
                      .userRepository
                      .removeUser();
                  if (!isRemoved || !context.mounted) return;
                  context
                    ..showSnackBar("Compte réinitialisé")
                    ..goToWelcome();
                },
                icon: const Icon(LucideIcons.logOut),
              ),
            ],
            showLeading: isMobile,
            onPop: () => context.goToHome(),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.insetMd,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: AppSpacing.giga,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        initial,
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    AppSpacing.gapVMd,
                    Text(
                      user.username,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapVLg,

                    Row(
                      children: [
                        Expanded(
                          child: AppOutlinedButton(
                            onPressed: () async {
                              await context.push("/profile/edit");
                              await _loadUser();
                            },
                            text: "Modifier dans l'écran dédié",
                            icon: const Icon(LucideIcons.userCheck),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapVLg,
                    const Divider(),
                    AppSpacing.gapVMd,

                    Text(
                      "Formulaire d'Édition Rapide",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapVMd,
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: AppSpacing.md,
                        children: [
                          AppTextFormField(
                            isRequired: true,
                            controller: _usernameController,
                            labelText: "Nom complet",
                            prefixIconData: LucideIcons.user,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validatorFunction: (v) {
                              if (v == null || v.trim().length < 3) {
                                return "Le nom doit faire au moins 3 caractères";
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            isRequired: true,
                            controller: _emailController,
                            labelText: "Adresse mail",
                            prefixIconData: LucideIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validatorFunction: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "L'adresse email est requise";
                              }
                              final emailRegex = RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                              );
                              if (!emailRegex.hasMatch(v.trim())) {
                                return "Adresse email invalide";
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            isRequired: true,
                            controller: _phoneController,
                            labelText: "Téléphone",
                            prefixIconData: LucideIcons.phone,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            validatorFunction: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return "Le téléphone est requis";
                              }
                              final phoneRegex = RegExp(r"^\+?[0-9\s\-]{8,}$");
                              if (!phoneRegex.hasMatch(v.trim())) {
                                return "Téléphone invalide (min 8 chiffres)";
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapVMd,
                          AppElevatedButton(
                            onPressed: _submitForm,
                            text: "VALIDER LE FORMULAIRE",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
