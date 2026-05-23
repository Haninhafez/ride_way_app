import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/utils/form_validators.dart';
import 'package:ride_way_app/features/auth/presentation/presenter/bloc/auth_bloc.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/continue_button.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
   final formkey = GlobalKey<FormState>();
 
 String? firstName;

  String? lastName;

  String? email;

  String? password;

  String? confirmPassword;

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
     appBar: AppBar(
      backgroundColor: theme.colorScheme.primaryContainer,
      title: const Text('RideWay'),
     ),
     body:Column()
    );
  }
}