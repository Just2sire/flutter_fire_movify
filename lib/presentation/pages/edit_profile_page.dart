import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/user.dart";
import "package:movify/presentation/providers/app_dependencies.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppElevatedButton, AppScaffold, AppTextFormField, AppTopbar;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AppDependencies.of(context).userRepository.getUser();
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    } catch (e) {
      debugPrint("Erreur chargement utilisateur : $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = User(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    AppDependencies.of(context).userRepository.saveUser(updatedUser);
    context
      ..showSnackBar("Profil mis à jour avec succès !")
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return AppScaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          AppTopbar(
            title: "Éditer le Profil",
            showLeading: true,
            onPop: () => context.pop(),
          ),
          AppSpacing.gapVMd,
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: AppSpacing.insetMd,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: AppSpacing.xl,
                        children: [
                          AppTextFormField(
                            controller: _usernameController,
                            labelText: "Nom complet",
                            isRequired: true,
                            prefixIconData: LucideIcons.user,
                            textCapitalization: TextCapitalization.words,
                            validatorFunction: (value) {
                              if (value == null || value.trim().length < 3) {
                                return "Le nom doit contenir au moins 3 caractères";
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: _emailController,
                            labelText: "Adresse e-mail",
                            isRequired: true,
                            prefixIconData: LucideIcons.mail,
                            keyboardType: TextInputType.emailAddress,
                            validatorFunction: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "L'adresse email est requise";
                              }
                              final emailRegex = RegExp(
                                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return "Veuillez entrer une adresse email valide";
                              }
                              return null;
                            },
                          ),
                          AppTextFormField(
                            controller: _phoneController,
                            labelText: "Numéro de téléphone",
                            isRequired: true,
                            prefixIconData: LucideIcons.phone,
                            keyboardType: TextInputType.phone,
                            validatorFunction: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Le numéro de téléphone est requis";
                              }
                              final phoneRegex = RegExp(r"^\+?[0-9\s\-]{8,}$");
                              if (!phoneRegex.hasMatch(value.trim())) {
                                return "Format de téléphone invalide (min. 8 chiffres)";
                              }
                              return null;
                            },
                          ),
                          AppSpacing.gapVMd,
                          AppElevatedButton(
                            onPressed: _submitForm,
                            text: "ENREGISTRER LES MODIFICATIONS",
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
