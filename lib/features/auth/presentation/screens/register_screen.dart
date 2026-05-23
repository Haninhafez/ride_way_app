import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_switcher.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/auth_toggle.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_viwe.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_appbar.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/login_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/regiseter_card.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/register_viwe.dart';
import 'package:ride_way_app/features/home/presentation/screen/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.loaderOverlay.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
        if (state is AuthError) {
          context.loaderOverlay.hide();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthLoading) {
          context.loaderOverlay.show();
        }
      },
      child: LoaderOverlay(child: RegisterViwe()),
    );
  }
}
