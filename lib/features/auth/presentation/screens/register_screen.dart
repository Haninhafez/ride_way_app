import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/widgets/toast_app.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/cubit/password_cubit.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/cubit/password_state.dart';
import 'package:ride_way_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/background_auth.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/checklist_item.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/password_strength_bar.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccount(PasswordCubit pwCubit) {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      AppToast.showError(
        context: context,
        message: 'Please accept the Terms & Privacy Policy',
      );
      return;
    }

    // Split full name into first/last for the existing BLoC event
    final parts = _firstNameController.text.trim().split(' ');
    final firstName = parts.first;
    final lastName = _lastNameController.text.trim();

    context.read<AuthBloc>().add(
      AuthRegisterEvent(
        firstName,
        lastName,
        _emailController.text.trim(),
        _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                setState(() => _isLoading = true);
              } else if (state is AuthSuccess) {
                setState(() => _isLoading = false);
                context.go('/home');
              } else if (state is AuthError) {
                setState(() => _isLoading = false);
                AppToast.showError(context: context, message: state.message);
              }
            },
            child: Scaffold(
              backgroundColor: kColorBackground,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Positioned(child: BackGroundAuth()),
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Header with back button ───────────────
                            AuthHeader(
                              showBackButton: true,
                              onBack: () => context.pop(),
                            ),
                            const SizedBox(height: 28),

                            // ── Card ──────────────────────────────────
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color.fromARGB(125, 0, 0, 0),
                                  // style: BorderStyle.none,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title & subtitle
                                  Text(
                                    context.tr('register.title'),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,

                                      color: kColorBorder,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    context.tr('register.subtitle'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: kColorSubtitle,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Full Name
                                  CustomTextField(
                                    label: context.tr(
                                      'register.first_name_label',
                                    ),
                                    hint: context.tr(
                                      'register.first_name_hint',
                                    ),
                                    prefixIcon: Icons.person_outline_rounded,
                                    controller: _firstNameController,
                                    keyboardType: TextInputType.name,
                                    autofillHints: const [AutofillHints.name],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Full name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  CustomTextField(
                                    label: 'register.last_name_label'.tr(),
                                    hint: context.tr('register.last_name_hint'),
                                    prefixIcon: Icons.person_outline_rounded,
                                    controller: _lastNameController,
                                    keyboardType: TextInputType.name,
                                    autofillHints: const [AutofillHints.name],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Full name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Email
                                  CustomTextField(
                                    label: 'register.email_label'.tr(),
                                    hint: context.tr('register.email_hint'),
                                    prefixIcon: Icons.mail_outline_rounded,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!v.contains('@'))
                                        return 'Invalid email';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password + live feedback
                                  BlocBuilder<PasswordCubit, PasswordState>(
                                    builder: (context, pwState) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PasswordTextField(
                                            label: context.tr(
                                              'register.password_label',
                                            ),
                                            hint: context.tr(
                                              'register.password_hint',
                                            ),
                                            controller: _passwordController,
                                            onChanged: (v) => context
                                                .read<PasswordCubit>()
                                                .updatePassword(v),
                                            validator: (v) {
                                              if (v == null || v.isEmpty) {
                                                return 'Password is required';
                                              }
                                              if (v.length < 8) {
                                                return 'Min 8 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 12),

                                          // Strength bar
                                          PasswordStrengthBar(
                                            strength: pwState.strength,
                                            weakLabel: context.tr(
                                              'register.strength_weak',
                                            ),
                                            mediumLabel: context.tr(
                                              'register.strength_medium',
                                            ),
                                            strongLabel: context.tr(
                                              'register.strength_strong',
                                            ),
                                          ),
                                          const SizedBox(height: 12),

                                          // Validation checklist
                                          ChecklistItem(
                                            label: context.tr(
                                              'register.check_min',
                                            ),
                                            isSatisfied: pwState.hasMinLength,
                                          ),
                                          const SizedBox(height: 6),
                                          ChecklistItem(
                                            label: context.tr(
                                              'register.check_upper',
                                            ),
                                            isSatisfied: pwState.hasUppercase,
                                          ),
                                          const SizedBox(height: 6),
                                          ChecklistItem(
                                            label: context.tr(
                                              'register.check_number',
                                            ),
                                            isSatisfied: pwState.hasNumber,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // Terms checkbox
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Checkbox(
                                          value: _termsAccepted,
                                          onChanged: (v) => setState(
                                            () => _termsAccepted = v!,
                                          ),
                                          activeColor: kColorPrimaryAction,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          side: const BorderSide(
                                            color: kColorBorder,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: kColorSubtitle,
                                              height: 1.5,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: context.tr(
                                                  'register.terms_prefix',
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.tr(
                                                  'register.terms_link',
                                                ),
                                                style: const TextStyle(
                                                  color: kColorAccentGold,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      kColorAccentGold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.tr(
                                                  'register.terms_middle',
                                                ),
                                              ),
                                              TextSpan(
                                                text: context.tr(
                                                  'register.privacy_link',
                                                ),
                                                style: const TextStyle(
                                                  color: kColorAccentGold,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      kColorAccentGold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),

                                  // Create account button
                                  BlocBuilder<PasswordCubit, PasswordState>(
                                    builder: (context, pwState) =>
                                        PrimaryButton(
                                          label: context.tr(
                                            'register.create_btn',
                                          ),
                                          onTap: () => _onCreateAccount(
                                            context.read<PasswordCubit>(),
                                          ),
                                          isLoading: _isLoading,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Footer
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${context.tr('register.have_account')} ',
                                    style: const TextStyle(
                                      color: kColorSubtitle,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => context.push('/login'),
                                    child: Text(
                                      context.tr('register.sign_in_link'),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: kColorAccentGold,
                                        decoration: TextDecoration.underline,
                                        decorationColor: kColorAccentGold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
