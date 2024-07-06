import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_day9_module17/ui/screens/authentication/reset_password_screen.dart';
import 'package:task_manager_day9_module17/ui/screens/authentication/sign_in_screen.dart';
import 'package:task_manager_day9_module17/ui/utility/app_colors.dart';
import 'package:task_manager_day9_module17/ui/widgets/background_widget.dart';

import '../../utility/app_colors.dart';
import '../../widgets/background_widget.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120,),
                  Text('Pin Verification', style: Theme.of(context).textTheme.titleLarge,),

                  Text('A 6 digit verification pin has been sent to your email address',
                    style: Theme.of(context).textTheme.titleSmall,),

                  SizedBox(height: 24,),

                  _buildPinCodeTextField(),
                  SizedBox(height: 16,),

                  ElevatedButton(onPressed: _onTapVerifyButton,
                    child: const Text('Verify'),),

                  const SizedBox(height: 36,),

                  _buildBackToSignInSection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection() {
    return Center(
                  child: RichText(text: TextSpan(
                      style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontWeight: FontWeight.w600,
                          letterSpacing: .4
                      ),
                      text: "Have account? ",
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(color: AppColors.themeColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _onTapSignInButton();
                            },
                        ),
                      ],
                    ),
                  ),
                );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedColor: AppColors.themeColor),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    keyboardType: TextInputType.number,
                    enableActiveFill: true,
                    controller: _pinTEController,
                    appContext: context,
                    length: 6);
  }

  _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }

  _onTapVerifyButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordScreen()
      ),
    );
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}
