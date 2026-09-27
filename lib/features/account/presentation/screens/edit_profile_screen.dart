import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/account/data/datasources/account_remote_data_source.dart';
import 'package:ride_way_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:ride_way_app/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/domain/usecases/update_user_profile_usecase.dart';
import 'package:ride_way_app/features/account/presentation/cubit/edit_profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/edit_profile_state.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_state.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDob;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _initControllers(EditProfileState state) {
    if (_firstNameController.text != state.firstName) {
      _firstNameController.text = state.firstName;
    }
    if (_lastNameController.text != state.lastName) {
      _lastNameController.text = state.lastName;
    }
    if (_emailController.text != state.email) {
      _emailController.text = state.email;
    }
    if (_phoneController.text != state.phoneNumber) {
      _phoneController.text = state.phoneNumber;
    }
    if (state.dateOfBirth != null && _selectedDob == null) {
      _selectedDob = state.dateOfBirth;
      _dobController.text =
          '${_selectedDob!.day.toString().padLeft(2, '0')} / ${_selectedDob!.month.toString().padLeft(2, '0')} / ${_selectedDob!.year}';
    }
  }

  Future<void> _pickDate(BuildContext context, EditProfileCubit cubit) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kColorPrimaryAction,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: kColorPrimaryAction,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
      });
      cubit.updateDob(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountRemoteDataSource = AccountRemoteDataSourceImpl();
    final accountRepository = AccountRepositoryImpl(
      remoteDataSource: accountRemoteDataSource,
    );
    final getUserProfileUseCase = GetUserProfileUseCase(accountRepository);
    final updateUserProfileUseCase =
        UpdateUserProfileUseCase(accountRepository);
    final profileCubit = ProfileCubit(
      getUserProfileUseCase: getUserProfileUseCase,
    );
    final editProfileCubit = EditProfileCubit(
      updateUserProfileUseCase: updateUserProfileUseCase,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (context) => profileCubit..loadProfile(),
        ),
        BlocProvider<EditProfileCubit>(
          create: (context) => editProfileCubit,
        ),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, profileState) {
          if (profileState.status == ProfileStatus.loaded &&
              profileState.profile != null) {
            final cubit = context.read<EditProfileCubit>();
            cubit.initFromProfile(profileState.profile!);
          }
        },
        child: BlocBuilder<EditProfileCubit, EditProfileState>(
          builder: (context, state) {
            final cubit = context.read<EditProfileCubit>();
            final isSaving = state.status == EditProfileStatus.loading;
            _initControllers(state);

            return Directionality(
              textDirection: Directionality.of(context),
              child: Scaffold(
                backgroundColor: kColorBackground,
                appBar: AppBar(
                  backgroundColor: kColorBackground,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.adaptive.arrow_back,
                      color: kColorPrimaryAction,
                    ),
                  ),
                  title: const Text(
                    'Edit profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kColorPrimaryAction,
                      fontFamily: 'ReadexPro',
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 120,
                      ),
                      child: Column(
                        children: [
                          Semantics(
                            label: 'Profile photo, tap camera to change',
                            child: Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 52,
                                    backgroundColor: kColorBackground,
                                    child: const Icon(
                                      Icons.person,
                                      color: kColorSubtitle,
                                      size: 56,
                                    ),
                                  ),
                                  Positioned(
                                    right: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? null
                                        : -2,
                                    left: Directionality.of(context) ==
                                            TextDirection.rtl
                                        ? -2
                                        : null,
                                    bottom: -2,
                                    child: Semantics(
                                      button: true,
                                      label: 'Change profile photo',
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: kColorPrimaryAction,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 3,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Change photo',
                              style: TextStyle(
                                color: kColorAccentGold,
                                decoration: TextDecoration.underline,
                                decorationColor: kColorAccentGold,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'First name',
                                  hint: 'Nasser',
                                  controller: _firstNameController,
                                  onChanged: (v) => cubit.updateFirstName(v),
                                  autofillHints: const [
                                    AutofillHints.givenName,
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Last name',
                                  hint: 'Al-Harbi',
                                  controller: _lastNameController,
                                  onChanged: (v) => cubit.updateLastName(v),
                                  autofillHints: const [
                                    AutofillHints.familyName,
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Email',
                            hint: 'you@example.com',
                            prefixIcon: Icons.email_outlined,
                            controller: _emailController,
                            onChanged: (v) => cubit.updateEmail(v),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: 16),
                          _buildPhoneField(cubit),
                          const SizedBox(height: 16),
                          _buildDobField(cubit),
                          const SizedBox(height: 16),
                          _buildNationalIdField(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 16,
                          bottom: MediaQuery.of(context).padding.bottom + 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, -4),
                            ),
                          ],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        child: PrimaryButton(
                          label: 'Save changes',
                          onTap: isSaving
                              ? null
                              : () async {
                                  await cubit.saveChanges();
                                  if (context.mounted) {
                                    if (state.status ==
                                        EditProfileStatus.saved) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Profile updated successfully',
                                          ),
                                          backgroundColor: kColorSuccess,
                                        ),
                                      );
                                      context.pop();
                                    } else if (state.status ==
                                        EditProfileStatus.error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            state.errorMessage ??
                                                'Failed to update profile',
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    }
                                  }
                                },
                          isLoading: isSaving,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField(EditProfileCubit cubit) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A3A3C),
            letterSpacing: 0.3,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: kColorFieldFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kColorBorder),
          ),
          child: Row(
            children: [
              if (!isRTL)
                _buildCountryCodePrefix()
              else
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    onChanged: (v) => cubit.updatePhone(v),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    style: const TextStyle(
                      fontSize: 15,
                      color: kColorPrimaryAction,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: '50 123 4567',
                      hintStyle: TextStyle(
                        color: kColorSubtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: kColorSubtitle,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              if (!isRTL)
                Container(
                  width: 1,
                  height: 32,
                  color: kColorBorder,
                )
              else
                Container(
                  width: 1,
                  height: 32,
                  color: kColorBorder,
                ),
              if (isRTL) _buildCountryCodePrefix(),
              if (!isRTL)
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    onChanged: (v) => cubit.updatePhone(v),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    style: const TextStyle(
                      fontSize: 15,
                      color: kColorPrimaryAction,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      hintText: '50 123 4567',
                      hintStyle: TextStyle(
                        color: kColorSubtitle,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: kColorSubtitle,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountryCodePrefix() {
    return Semantics(
      label: 'Country code +966 Saudi Arabia',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(12),
            right: Radius.zero,
          ),
        ),
        child: const Text(
          '+966',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: kColorPrimaryAction,
            fontFamily: 'Outfit',
          ),
        ),
      ),
    );
  }

  Widget _buildDobField(EditProfileCubit cubit) {
    return Semantics(
      label: 'Date of birth, tap to pick date',
      child: GestureDetector(
        onTap: () => _pickDate(context, cubit),
        behavior: HitTestBehavior.opaque,
        child: AbsorbPointer(
          child: CustomTextField(
            label: 'Date of birth',
            hint: 'DD / MM / YYYY',
            prefixIcon: Icons.calendar_today_outlined,
            controller: _dobController,
          ),
        ),
      ),
    );
  }

  Widget _buildNationalIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'National ID / Iqama',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3A3A3C),
            letterSpacing: 0.3,
            fontFamily: 'Outfit',
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'National ID verified with Nafath',
          child: Container(
            decoration: BoxDecoration(
              color: kColorBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kColorBorder),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.fingerprint,
                  color: kColorAccentGold,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '1094 5528 31',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kColorPrimaryAction,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                Icon(
                  Icons.lock_outline,
                  color: kColorSubtitle,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: 'Verified with Nafath, contact support to change',
          child: const Text(
            'Verified with Nafath — contact support to change it.',
            style: TextStyle(
              fontSize: 12,
              color: kColorSubtitle,
              fontFamily: 'Outfit',
            ),
          ),
        ),
      ],
    );
  }
}
