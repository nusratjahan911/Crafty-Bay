
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/auth/presentation/widgets/app_logo.dart';
import 'package:flutter/material.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});



  static const String name = '/reset_password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppLogo(width: 90),
                  const SizedBox(height: 16),
                  Text(
                    'Reset Password',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordTEController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Confirm password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Confirm Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                   FilledButton(
                        onPressed: _onTapSignInButton,
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        ),
    );
  }

  void _onTapSignInButton(){
    Navigator.pushNamed(context, SignInScreen.name);
  }

}
