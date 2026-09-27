import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/account/data/datasources/account_remote_data_source.dart';
import 'package:ride_way_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:ride_way_app/features/account/domain/repositories/account_repository.dart';
import 'package:ride_way_app/features/account/domain/usecases/change_password_usecase.dart';
import 'package:ride_way_app/features/account/presentation/cubit/password_security_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/password_security_state.dart'
    as ps;
import 'package:ride_way_app/features/auth/presentation/widgets/checklist_item.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/password_strength_bar.dart'
    as pw;
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';

class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  @override
  Widget build(BuildContext context) {
    final AccountRemoteDataSource remoteDataSource =
        AccountRemoteDataSourceImpl();
    final AccountRepository accountRepository =
        AccountRepositoryImpl(remoteDataSource: remoteDataSource);
    final ChangePasswordUseCase changePasswordUseCase =
        ChangePasswordUseCase(accountRepository);

    return BlocProvider(
      create: (_) => PasswordSecurityCubit(
        changePasswordUseCase: changePasswordUseCase,
        accountRepository: accountRepository,
      )..loadLastChangedInfo(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<PasswordSecurityCubit>();
          return Scaffold(
            backgroundColor: kColorBackground,
            appBar: AppBar(
              backgroundColor: kColorBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  color: kColorPrimaryAction,
                  size: 20,
                ),
              ),
              title: const Text(
                'Password & security',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: kColorPrimaryAction,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: kColorBorder.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: kColorSubtitle,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Changing your password signs you out of all other devices.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kColorPrimaryAction,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                            BlocBuilder<PasswordSecurityCubit,
                                ps.PasswordSecurityState>(
                              builder: (context, state) {
                                return CustomTextField(
                                  hint: 'Enter current password',
                                  label: 'Current password',
                                  onChanged: cubit.updateCurrent,
                                  obscureText: !state.showCurrent,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  suffixIcon: GestureDetector(
                                    onTap: cubit.toggleCurrentVis,
                                    child: Icon(
                                      state.showCurrent
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: kColorSubtitle,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<PasswordSecurityCubit,
                                ps.PasswordSecurityState>(
                              builder: (context, state) {
                                return CustomTextField(
                                  hint: 'Create new password',
                                  label: 'New password',
                                  onChanged: cubit.updateNew,
                                  obscureText: !state.showNew,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  suffixIcon: GestureDetector(
                                    onTap: cubit.toggleNewVis,
                                    child: Icon(
                                      state.showNew
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: kColorSubtitle,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<PasswordSecurityCubit,
                                ps.PasswordSecurityState>(
                              builder: (context, state) {
                                return CustomTextField(
                                  hint: 'Re-enter new password',
                                  label: 'Confirm new password',
                                  onChanged: cubit.updateConfirm,
                                  obscureText: !state.showConfirm,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  suffixIcon: GestureDetector(
                                    onTap: cubit.toggleConfirmVis,
                                    child: Icon(
                                      state.showConfirm
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: kColorSubtitle,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Forgot your current password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kColorAccentGold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password strength',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kColorPrimaryAction,
                              ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<PasswordSecurityCubit,
                                ps.PasswordSecurityState>(
                              builder: (context, state) {
                                pw.PasswordStrength mappedStrength;
                                switch (state.passwordStrength) {
                                  case ps.PasswordStrength.none:
                                    mappedStrength = pw.PasswordStrength.none;
                                    break;
                                  case ps.PasswordStrength.weak:
                                    mappedStrength = pw.PasswordStrength.weak;
                                    break;
                                  case ps.PasswordStrength.medium:
                                    mappedStrength = pw.PasswordStrength.medium;
                                    break;
                                  case ps.PasswordStrength.strong:
                                    mappedStrength = pw.PasswordStrength.strong;
                                    break;
                                }
                                return pw.PasswordStrengthBar(
                                    strength: mappedStrength);
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your password must have:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kColorSubtitle,
                              ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<PasswordSecurityCubit,
                                ps.PasswordSecurityState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    ChecklistItem(
                                      label: 'At least 8 characters',
                                      isSatisfied: state.hasMinChars,
                                    ),
                                    const SizedBox(height: 8),
                                    ChecklistItem(
                                      label: 'One uppercase letter',
                                      isSatisfied: state.hasUppercase,
                                    ),
                                    const SizedBox(height: 8),
                                    ChecklistItem(
                                      label: 'One number',
                                      isSatisfied: state.hasNumber,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF2E6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              color: Color(0xFF5B7A38),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: BlocBuilder<PasswordSecurityCubit,
                                  ps.PasswordSecurityState>(
                                builder: (context, state) {
                                  return RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF3A4A22),
                                        height: 1.4,
                                        fontFamily: 'San-Francisco-Pro',
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Security',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const TextSpan(text: '  '),
                                        TextSpan(
                                          text: state.lastChangedInfo ??
                                              'Last changed 4 months ago from Riyadh, SA. Enable two-factor login in Help & support for extra protection.',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      16 + MediaQuery.of(context).padding.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 20,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: BlocBuilder<PasswordSecurityCubit,
                        ps.PasswordSecurityState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          label: 'Update password',
                          onTap: cubit.updatePassword,
                          isLoading:
                              state.status == ps.PasswordSecurityStatus.updating,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
