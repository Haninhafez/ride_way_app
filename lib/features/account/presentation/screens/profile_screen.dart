import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/di/injecation.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/core/themes/theme_notfire.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_state.dart';
import 'package:ride_way_app/features/account/presentation/screens/edit_profile_screen.dart';
import 'package:ride_way_app/features/account/presentation/screens/password_security_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color colorContainer = Theme.of(context).colorScheme.primaryContainer;

    return BlocProvider<ProfileCubit>(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final profile = state.profile;
          final isLoading = state.status == ProfileStatus.loading;

          return Directionality(
            textDirection: Directionality.of(context),
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: 'profile.profile_card'.tr(),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colorContainer,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    label: 'profile.user_avatar'.tr(),
                                    child: CircleAvatar(
                                      radius: 36,
                                      child: const Icon(Icons.person, size: 40),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Semantics(
                                                label: 'profile.user_name'.tr(),
                                                child: Text(
                                                  profile != null
                                                      ? '${profile.firstName} ${profile.lastName}'
                                                      : 'profile.default_name'
                                                            .tr(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'ReadexPro',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Semantics(
                                                label: 'profile.membership'
                                                    .tr(),
                                                child: Text(
                                                  profile?.tier ??
                                                      'profile.gold'.tr(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: kColorAccentGold,
                                                    fontFamily: 'Outfit',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Semantics(
                                          label: 'profile.email_address'.tr(),
                                          child: Text(
                                            profile?.email ??
                                                'nasser.alharbi@mail.com',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Outfit',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Semantics(
                                              label: 'profile.points_semantics'.tr(
                                                args: [
                                                  '${profile?.points ?? 12480}',
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (profile?.points ?? 12480)
                                                        .toString()
                                                        .replaceAllMapped(
                                                          RegExp(
                                                            r'(\d{1,3})(?=(\d{3})+(?!\d))',
                                                          ),
                                                          (Match m) =>
                                                              '${m[1]},',
                                                        ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'profile.points'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Semantics(
                                              label: 'profile.trips_semantics'.tr(
                                                args: [
                                                  '${profile?.totalTrips ?? 34}',
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (profile?.totalTrips ?? 34)
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'profile.trips'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Semantics(
                                              label: 'profile.member_since'.tr(
                                                args: [
                                                  profile?.memberSince ??
                                                      '2023',
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    profile?.memberSince ??
                                                        '2023',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'profile.since'.tr(),
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'profile.edit_profile'.tr(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Outfit',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: kColorBorder),
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Semantics(
                        label: 'profile.account_group'.tr(),

                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.person_outline,
                                title: 'profile.personal_details'.tr(),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.lock_outline,
                                title: 'profile.password_security'.tr(),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PasswordSecurityScreen(),
                                    ),
                                  );
                                },
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.confirmation_num_outlined,
                                title: 'profile.booking_history'.tr(),
                                trailingBadge: 'profile.trips_count'.tr(
                                  args: ['${profile?.totalTrips ?? 34}'],
                                ),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.credit_card_outlined,
                                title: 'profile.payment_methods'.tr(),
                                trailingBadge: 'profile.cards_count'.tr(
                                  args: ['2'],
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'profile.preferences_group'.tr(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.language_outlined,
                                title: 'profile.language'.tr(),
                                trailing: Text(
                                  context.locale.languageCode == 'ar'
                                      ? 'profile.arabic'.tr()
                                      : 'profile.english'.tr(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kColorSubtitle,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                onTap: () => _showLanguagePicker(context),
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SwitchTile(
                                icon: Icons.notifications_outlined,
                                title: 'profile.trip_notifications'.tr(),
                                value: state.notificationsEnabled,
                                onChanged: (v) => cubit.toggleNotifications(v),
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              Consumer<ThemeNotifier>(
                                builder: (context, notifier, child) {
                                  return _SwitchTile(
                                    icon: Icons.dark_mode_outlined,
                                    title: 'profile.dark_mode'.tr(),
                                    value: notifier.isDarkMode,
                                    onChanged: (_) {
                                      notifier.toggleDarkMode();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'profile.support_group'.tr(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _SettingsTile(
                                icon: Icons.help_outline,
                                title: 'profile.help_support'.tr(),
                                onTap: () {
                                  context.push('/support');
                                },
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.gavel_outlined,
                                title: 'profile.terms_privacy'.tr(),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: 'profile.logout'.tr(),
                                    barrierColor: Colors.black54,
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: _LogoutDialog(
                                                onConfirm: () async {
                                                  await CacheHelper.clearData();
                                                  context.go('/');
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                    transitionBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutBack,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                  );
                                },
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFFC0392B),
                            size: 20,
                          ),
                          label: Text(
                            'profile.logout'.tr(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC0392B),
                              fontFamily: 'Outfit',
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: const BorderSide(color: Color(0xFFF5D7D2)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Semantics(
                          label: 'profile.app_version_semantics'.tr(),
                          child: Text(
                            'profile.app_version'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: kColorSubtitle,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> _showLanguagePicker(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final currentLanguage = context.locale.languageCode;
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'profile.choose_language'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('profile.english'.tr()),
              trailing: currentLanguage == 'en'
                  ? const Icon(Icons.check, color: kColorAccentGold)
                  : null,
              onTap: () async {
                await context.setLocale(const Locale('en'));
                if (sheetContext.mounted) Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('profile.arabic'.tr()),
              trailing: currentLanguage == 'ar'
                  ? const Icon(Icons.check, color: kColorAccentGold)
                  : null,
              onTap: () async {
                await context.setLocale(const Locale('ar'));
                if (sheetContext.mounted) Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.trailingBadge,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? trailingBadge;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.RTL;
    final chevronIcon = isRTL ? Icons.arrow_back_ios : Icons.arrow_forward_ios;

    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(icon, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                if (trailingBadge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      trailingBadge!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kColorAccentGold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  )
                else if (trailing != null)
                  trailing!,
                if (onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(chevronIcon, size: 14),
                ],
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      toggled: value,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(icon, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                Semantics(
                  label: 'profile.switch_semantics'.tr(
                    args: [
                      title,
                      value ? 'profile.on'.tr() : 'profile.off'.tr(),
                    ],
                  ),
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeThumbColor: kColorAccentGold,
                    activeTrackColor: kColorAccentGold.withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: kColorBorder,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(55),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kColorAccentGold),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kColorBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF5D7D2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.logout, color: Color(0xFFC0392B), size: 28),
          ),
          const SizedBox(height: 20),
          Text(
            'profile.logout_title'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'ReadexPro',
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'profile.logout_message'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: kColorSubtitle,
                height: 1.5,
                fontFamily: 'Outfit',
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: kColorAccentGold,

                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                side: const BorderSide(color: kColorAccentGold),
              ),
              child: Text(
                'profile.cancel'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                side: BorderSide(color: Colors.red.shade900),
              ),
              child: Text(
                'profile.confirm_logout'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                  color: Colors.red.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
