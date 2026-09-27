import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/account/data/datasources/account_remote_data_source.dart';
import 'package:ride_way_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:ride_way_app/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountRemoteDataSource = AccountRemoteDataSourceImpl();
    final accountRepository = AccountRepositoryImpl(
      remoteDataSource: accountRemoteDataSource,
    );
    final getUserProfileUseCase = GetUserProfileUseCase(accountRepository);
    final profileCubit = ProfileCubit(
      getUserProfileUseCase: getUserProfileUseCase,
    );

    return BlocProvider<ProfileCubit>(
      create: (context) => profileCubit..loadProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final profile = state.profile;
          final isLoading = state.status == ProfileStatus.loading;

          return Directionality(
            textDirection: Directionality.of(context),
            child: Scaffold(
              backgroundColor: kColorBackground,
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
                        label: 'Profile information card',
                        child: Container(
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
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Semantics(
                                    label: 'User avatar',
                                    child: CircleAvatar(
                                      radius: 36,
                                      backgroundColor: kColorBackground,
                                      child: const Icon(
                                        Icons.person,
                                        color: kColorSubtitle,
                                        size: 40,
                                      ),
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
                                                label: 'User name',
                                                child: Text(
                                                  profile != null
                                                      ? '${profile.firstName} ${profile.lastName}'
                                                      : 'Nasser Al-Harbi',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: kColorPrimaryAction,
                                                    fontFamily: 'ReadexPro',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFBEFE3),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Semantics(
                                                label: 'Membership tier',
                                                child: Text(
                                                  profile?.tier ?? 'Gold',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600,
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
                                          label: 'Email address',
                                          child: Text(
                                            profile?.email ??
                                                'nasser.alharbi@mail.com',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: kColorSubtitle,
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
                                              label:
                                                  '${profile?.points ?? 12480} points',
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (profile?.points ?? 12480)
                                                        .toString()
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) =>
                                                                '${m[1]},'),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: kColorPrimaryAction,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'Points',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: kColorSubtitle,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Semantics(
                                              label:
                                                  '${profile?.totalTrips ?? 34} trips',
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
                                                      color: kColorPrimaryAction,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'Trips',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: kColorSubtitle,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Semantics(
                                              label:
                                                  'Member since ${profile?.memberSince ?? '2023'}',
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
                                                      color: kColorPrimaryAction,
                                                      fontFamily: 'Outfit',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  const Text(
                                                    'Since',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: kColorSubtitle,
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
                                    context.push('/profile/edit');
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Edit profile',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: kColorPrimaryAction,
                                    side: const BorderSide(
                                      color: kColorBorder,
                                    ),
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
                        label: 'Account settings group',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                title: 'Personal details',
                                onTap: () {},
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.lock_outline,
                                title: 'Password & security',
                                onTap: () {
                                  context.push('/profile/password');
                                },
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.confirmation_num_outlined,
                                title: 'Booking history',
                                trailingBadge: '34 trips',
                                onTap: () {},
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SettingsTile(
                                icon: Icons.credit_card_outlined,
                                title: 'Payment methods',
                                trailingBadge: '2 cards',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Preferences settings group',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                title: 'Language',
                                trailing: Text(
                                  state.selectedLanguage,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: kColorSubtitle,
                                    fontFamily: 'Outfit',
                                  ),
                                ),
                                onTap: () {},
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SwitchTile(
                                icon: Icons.notifications_outlined,
                                title: 'Trip notifications',
                                value: state.notificationsEnabled,
                                onChanged: (v) =>
                                    cubit.toggleNotifications(v),
                              ),
                              const Divider(
                                height: 1,
                                color: kColorBorder,
                                indent: 56,
                              ),
                              _SwitchTile(
                                icon: Icons.dark_mode_outlined,
                                title: 'Dark mode',
                                value: state.darkModeEnabled,
                                onChanged: (v) => cubit.toggleDarkMode(v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Support and legal group',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                title: 'Help & support',
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
                                title: 'Terms & privacy',
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
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (ctx) => _LogoutBottomSheet(
                                      onConfirm: () {
                                        Navigator.pop(ctx);
                                        cubit.logout();
                                        context.go('/login');
                                      },
                                    ),
                                  );
                                },
                          icon: const Icon(
                            Icons.logout,
                            color: Color(0xFFC0392B),
                            size: 20,
                          ),
                          label: const Text(
                            'Log out',
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
                              side: const BorderSide(
                                color: Color(0xFFF5D7D2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Semantics(
                          label: 'App version 2.4.0 build 318',
                          child: const Text(
                            'RideWay v2.4.0 · Build 318',
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
    final isRTL = Directionality.of(context) == TextDirection.rtl;
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
                Icon(
                  icon,
                  color: kColorPrimaryAction,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kColorPrimaryAction,
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
                      color: const Color(0xFFFBEFE3),
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
                  Icon(
                    chevronIcon,
                    size: 14,
                    color: kColorSubtitle,
                  ),
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
                Icon(
                  icon,
                  color: kColorPrimaryAction,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kColorPrimaryAction,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                Semantics(
                  label: '$title switch, ${value ? 'on' : 'off'}',
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeThumbColor: kColorAccentGold,
                    activeTrackColor: kColorAccentGold.withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: kColorBorder,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
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

class _LogoutBottomSheet extends StatelessWidget {
  const _LogoutBottomSheet({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
          .copyWith(bottom: bottomPadding + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
            child: const Icon(
              Icons.logout,
              color: Color(0xFFC0392B),
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Log out of RideWay?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: kColorPrimaryAction,
              fontFamily: 'ReadexPro',
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'You will need to sign in again to access your bookings, rewards, and account settings.',
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
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Yes, log out',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kColorPrimaryAction,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
