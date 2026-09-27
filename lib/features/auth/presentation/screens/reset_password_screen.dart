import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/cubit/password_cubit.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/cubit/password_state.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/checklist_item.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/otp_input_row.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/password_strength_bar.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';

/// Reset password screen combining OTP verification and new password entry.
///
/// [email] is passed via GoRouter query parameter and displayed in the subtitle.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _otpCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onUpdatePassword(PasswordCubit pwCubit) {
    if (_otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit code')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    // TODO: Wire to reset-password BLoC/repository event when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password updated! Please sign in.'),
        backgroundColor: kColorSuccess,
      ),
    );
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: kColorBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header with back button ─────────────────
                    AuthHeader(
                      showBackButton: true,
                      onBack: () => context.pop(),
                    ),
                    const SizedBox(height: 28),

                    // ── Card ────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kColorFieldFill,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            context.tr('reset.title'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: kColorPrimaryAction,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Subtitle with email
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: kColorSubtitle,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: '${context.tr('reset.subtitle')} '),
                                TextSpan(
                                  text: widget.email.isNotEmpty
                                      ? widget.email
                                      : 'your email',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kColorPrimaryAction,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ── 6-Digit OTP Row (strict LTR) ────
                          const Text(
                            'Verification Code',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3A3A3C),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OtpInputRow(
                            onCompleted: (code) =>
                                setState(() => _otpCode = code),
                          ),
                          const SizedBox(height: 28),

                          // ── New Password + live feedback ─────
                          BlocBuilder<PasswordCubit, PasswordState>(
                            builder: (context, pwState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PasswordTextField(
                                    label: context.tr('reset.new_password_label'),
                                    hint: context.tr('reset.new_password_hint'),
                                    controller: _newPasswordController,
                                    onChanged: (v) => context
                                        .read<PasswordCubit>()
                                        .updatePassword(v),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'New password is required';
                                      }
                                      if (v.length < 8) return 'Min 8 characters';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // Strength bar
                                  PasswordStrengthBar(
                                    strength: pwState.strength,
                                    weakLabel: context.tr('reset.check_min'),
                                    mediumLabel: 'Medium',
                                    strongLabel: 'Strong',
                                  ),
                                  const SizedBox(height: 12),

                                  // Checklist
                                  ChecklistItem(
                                    label: context.tr('reset.check_min'),
                                    isSatisfied: pwState.hasMinLength,
                                  ),
                                  const SizedBox(height: 6),
                                  ChecklistItem(
                                    label: context.tr('reset.check_upper'),
                                    isSatisfied: pwState.hasUppercase,
                                  ),
                                  const SizedBox(height: 6),
                                  ChecklistItem(
                                    label: context.tr('reset.check_number'),
                                    isSatisfied: pwState.hasNumber,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // ── Confirm New Password ─────────────
                          PasswordTextField(
                            label: context.tr('reset.confirm_label'),
                            hint: context.tr('reset.confirm_hint'),
                            controller: _confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (v != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          // ── Update button ────────────────────
                          BlocBuilder<PasswordCubit, PasswordState>(
                            builder: (context, pwState) => PrimaryButton(
                              label: context.tr('reset.update_btn'),
                              onTap: () => _onUpdatePassword(
                                context.read<PasswordCubit>(),
                              ),
                              isLoading: _isLoading,
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
        ),
      ),
    );
  }
}
