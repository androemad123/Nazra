import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/providers/theme_provider.dart';
import '../../../routing/routes.dart';
import '../../resources/color_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/app_text_btn.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/divider_with_text.dart';
import '../../widgets/social_auth_btn.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isDarkMode
                ? [
              Theme.of(context).colorScheme.surface, // beige
              Theme.of(context).colorScheme.secondary, // lighter brown
              Theme.of(context).colorScheme.surface, // beige
            ]
                : [
              Theme.of(context).colorScheme.surface, // beige
              Theme.of(context).colorScheme.background, // white
              Theme.of(context).colorScheme.surface, // beige
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Create ",
                        style: semiBoldStyle(
                          fontSize: 40,
                          color: Colors.transparent,
                        ).copyWith(
                          foreground: Paint()
                            ..shader = LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.centerRight,
                              colors: [
                                ColorManager.brown,
                                ColorManager.cream,
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 110, 0, 100),
                            ),
                        ),
                      ),
                      TextSpan(
                        text: "Your", //
                        style: semiBoldStyle(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "Account",
                  style: semiBoldStyle(fontSize: 40, color: Colors.black),
                ),
                AppTextField(
                  hintText: "Full name",
                  isPassword: false,
                  controller: textEditingController,
                  prefixIcon: Icons.person_3_outlined,
                ),
                AppTextField(
                  hintText: "Email",
                  isPassword: true,
                  controller: textEditingController,
                  prefixIcon: Icons.email_outlined,
                ),
                AppTextField(
                  hintText: "Phone number",
                  isPassword: true,
                  controller: textEditingController,
                  prefixIcon: Icons.phone_iphone_outlined,
                ),
                AppTextField(
                  hintText: "Password",
                  isPassword: true,
                  controller: textEditingController,
                  prefixIcon: Icons.phone_iphone_outlined,
                ),
                AppTextField(
                  hintText: "Confirm password",
                  isPassword: true,
                  controller: textEditingController,
                  prefixIcon: Icons.phone_iphone_outlined,
                ),
                SizedBox(
                  height: 15,
                ),
                AppTextBtn(
                    buttonText: "Sign Up",
                    textStyle: semiBoldStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    onPressed: () {}),
                SizedBox(
                  height: 20,
                ),
                DividerWithText(
                  text: "Or sign up with",
                  lineColor: Colors.grey.shade400,
                  textStyle: regularStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialAuthBtn( assetPath: 'assets/images/google.jpg',onTap: (){},),
                    const SizedBox(width: 25),
                    SocialAuthBtn( assetPath: 'assets/images/facebook.jpg', onTap: () {
                      // Facebook sign in
                    }),
                    const SizedBox(width: 25),
                    SocialAuthBtn(assetPath: 'assets/images/apple.jpg', onTap: () {
                      // Apple sign in
                    }),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t Already have an account? ',
                      style: regularStyle(fontSize: 16, color: Colors.black54),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign in',
                          style: semiBoldStyle(
                            fontSize: 16,
                            color: ColorManager.brown,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed(Routes.loginRoute);
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
    );

  }
}