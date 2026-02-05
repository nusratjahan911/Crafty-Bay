import 'dart:async';

import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/auth/data/models/verify_otp_params.dart';
import 'package:crafty_bay/features/auth/presentation/providers/verify_otp_provider.dart';
import 'package:crafty_bay/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:crafty_bay/features/auth/presentation/widgets/app_logo.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/snack_bar_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.email});

  final String email;

  static const String name = '/otp';

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VerifyOtpProvider _verifyOtpProvider = VerifyOtpProvider();

  static const int _initialTime = 120;
  int _remainingTime = _initialTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingTime = _initialTime;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onTapResendCode() {
    _startTimer(); // restart countdown only
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return ChangeNotifierProvider(
      create: (_) => _verifyOtpProvider,
      child: Scaffold(
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
                    const SizedBox(height: 8),

                    Text(
                      'Enter OTP Code',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'A 4 digit otp code has been sent',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 16),

                    /// OTP Input
                    PinCodeTextField(
                      length: 4,
                      animationType: AnimationType.fade,
                      controller: _otpTEController,
                      appContext: context,
                      backgroundColor: Colors.transparent,
                      animationDuration: const Duration(milliseconds: 300),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(6),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Consumer<VerifyOtpProvider>(
                      builder: (context, verifyOtpProvider, child) {
                        if (_verifyOtpProvider.verifyOtpInProgress) {
                          return CenterCircularProgress();
                        }
                        return FilledButton(
                          onPressed: _onTapVerifyButton,
                          child: const Text('Verify Otp'),
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    RichText(
                      text: TextSpan(
                        style: textTheme.bodyMedium,
                        text: 'Already have an account? ',
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppColours.themeColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Countdown and Resend
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: textTheme.bodySmall,
                            text: 'This code will expire in ',
                            children: [
                              TextSpan(
                                text: '${_remainingTime}s',
                                style: TextStyle(
                                  color: AppColours.themeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        TextButton(
                          onPressed: _remainingTime == 0
                              ? _onTapResendCode
                              : null,
                          child: Text(
                            'Resend Code',
                            style: textTheme.bodySmall?.copyWith(
                              color: _remainingTime == 0
                                  ? AppColours.themeColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapVerifyButton() {
    if (_formKey.currentState!.validate()) {
      _verifyOtp();
    }
  }

  void _onTapSignInButton() {
    Navigator.pushReplacementNamed(context, SignInScreen.name);
  }



  Future<void> _verifyOtp() async {
    VerifyOtpParams params = VerifyOtpParams(
      email: widget.email,
      otp: _otpTEController.text,
    );
    final bool isSuccess = await _verifyOtpProvider.verifyOtp(params);
    if (isSuccess) {
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate) => false);
    } else {
      ShowSnackBarMessage(context, _verifyOtpProvider.errorMessage!);
    }
  }
}
