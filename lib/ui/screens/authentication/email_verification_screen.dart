import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_day9_module17/ui/screens/authentication/pin_verification_screen.dart';

import '../../utility/app_colors.dart';
import '../../widgets/background_widget.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();

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
                  Text('Your Email Address', style: Theme.of(context).textTheme.titleLarge,),
                  Text('A 6 digit verification pin will send to your email address',
                    style: Theme.of(context).textTheme.titleSmall,),

                  SizedBox(height: 24,),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: InputDecoration(
                      hintText: 'Email'
                    ),
                  ),

                  SizedBox(height: 16,),

                  ElevatedButton(onPressed: _onTapConfirmButton,
                    child: Icon(Icons.arrow_circle_right_outlined),),

                  SizedBox(height: 36,),

                  Center(
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTapSignInButton(){
    Navigator.pop(context);
  }

  _onTapConfirmButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PinVerificationScreen();
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
