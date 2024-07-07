import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_day9_module17/ui/controller/auth_controller.dart';
import 'package:task_manager_day9_module17/ui/screens/authentication/reset_password_screen.dart';
import 'package:task_manager_day9_module17/ui/screens/authentication/sign_in_screen.dart';
import 'package:task_manager_day9_module17/ui/utility/app_colors.dart';
import 'package:task_manager_day9_module17/ui/widgets/background_widget.dart';
import 'package:task_manager_day9_module17/ui/widgets/centered_progress_indicator.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utility/urls.dart';
import '../../widgets/show_snack_bar_message.dart';


class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key,});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  bool _getPinVerificationInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120,),
                    Text('Pin Verification', style: Theme.of(context).textTheme.titleLarge,),

                    Text('A 6 digit verification pin has been sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,),

                    const SizedBox(height: 24,),

                    _buildPinCodeTextField(),
                    const SizedBox(height: 16,),

                    Visibility(
                      visible: _getPinVerificationInProgress == false,
                      replacement: const CenteredProgressIndicator(),
                      child: ElevatedButton(onPressed: _pinVerification,
                        child: const Text('Verify'),),
                    ),

                    const SizedBox(height: 36,),

                    _buildBackToSignInSection()
                  ],
                ),
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
                          style: const TextStyle(color: AppColors.themeColor),
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
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    keyboardType: TextInputType.number,
                    enableActiveFill: true,
                    controller: _pinTEController,
                    appContext: context,
                    length: 6);
  }

  Future<void> _pinVerification() async{
    _getPinVerificationInProgress = true;
    if(mounted){
      setState(() {});
    }

    // Map<String, dynamic> requestData = {
    //   "email":_emailTEController.text.trim(),
    // };
    final userData = AuthController.userData!;
    String mail = userData.email ?? '';
    print(mail);
    NetworkResponse response = await NetworkCaller.getRequest(Urls.otpVerification(mail, _pinTEController.text));//NetworkResponse class er object create korci first then NetworkCaller k call korci

    _getPinVerificationInProgress = false;
    if(mounted){
      setState(() {});
    }

    if (response.isSuccess) {
      clear();
      if(mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen()
          ),
        );
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'otp is not correct. Try again');
      }
    }
  }

  _onTapSignInButton(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }

  clear(){
    _pinTEController.clear();
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}
