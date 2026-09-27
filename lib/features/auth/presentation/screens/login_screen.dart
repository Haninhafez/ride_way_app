import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/widgets/toast_app.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/background_auth.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/social_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepSignedIn = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginEvent(_emailController.text.trim(), _passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        resizeToAvoidBottomInset: false,
        backgroundColor: kColorBackground,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Logo & Brand ──────────────────────────────────
                      const AuthHeader(),
                      const SizedBox(height: 32),

                      // ── Card ─────────────────────────────────────────
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
                              context.tr('login.welcome'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: kColorBorder,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.tr('login.subtitle'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: kColorBorder,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Email field
                            CustomTextField(
                              label: context.tr('login.email_label'),
                              hint: context.tr('login.email_hint'),
                              prefixIcon: Icons.mail_outline_rounded,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return context.tr('login.email_hint');
                                }
                                if (!v.contains('@')) return 'Invalid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            PasswordTextField(
                              label: context.tr('login.password_label'),
                              hint: '••••••••',
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _onSignIn(),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Enter password';
                                if (v.length < 6) return 'Min 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Keep signed in + Forgot password row
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _keepSignedIn,
                                    onChanged: (v) =>
                                        setState(() => _keepSignedIn = v!),
                                    activeColor: kColorPrimaryAction,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(color: kColorBorder),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.tr('login.keep_signed'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: kColorBorder,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => context.push(
                                    '/reset-password?email=${_emailController.text.trim()}',
                                  ),
                                  child: Text(
                                    context.tr('login.forgot'),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: kColorBorder,
                                      decoration: TextDecoration.underline,
                                      decorationColor: kColorSubtitle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),

                            // Sign in button
                            PrimaryButton(
                              label: context.tr('login.sign_in'),
                              onTap: _onSignIn,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: 24),

                            // Divider
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: kColorBorder,
                                    endIndent: 12,
                                  ),
                                ),
                                Text(
                                  context.tr('login.or_continue'),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: kColorSubtitle,
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: kColorBorder,
                                    indent: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Social auth buttons
                            Row(
                              children: [
                                SocialAuthButton(
                                  label: context.tr('login.apple'),
                                  svgAsset:
                                      'assets/images/app_images/apple.svg',
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Apple Sign-In coming soon',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                SocialAuthButton(
                                  label: context.tr('login.nafath'),
                                  iconData: Icons.shield_outlined,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Nafath ID coming soon'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer link
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${context.tr('login.no_account')} ',
                              style: const TextStyle(
                                color: kColorSubtitle,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/register'),
                              child: Text(
                                context.tr('login.create_account_link'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kColorAccentGold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: KColorDarkGold,
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
  }
}
