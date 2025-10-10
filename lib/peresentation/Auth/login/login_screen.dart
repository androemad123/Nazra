import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:nazra/peresentation/resources/value_manager.dart';
import 'package:nazra/peresentation/widgets/app_text_btn.dart';
import 'package:nazra/peresentation/widgets/social_auth_btn.dart';
import 'package:nazra/routing/routes.dart';
import 'package:provider/provider.dart';

import '../../../app/providers/theme_provider.dart';
import '../../resources/color_manager.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/divider_with_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        child: SafeArea(
          top: true,
          minimum: EdgeInsets.only(top: 70.h),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p18),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: semiBoldStyle(
                      fontSize: 40.sp,
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
                          const Rect.fromLTWH(
                              0, 110, 0, 100), // width/height of the text box
                        ),
                    ),
                  ),
                  Text(
                    "Back",
                    style: semiBoldStyle(fontSize: 40.sp, color: Colors.black),
                  ),
                  AppTextField(
                    hintText: "Email",
                    isPassword: false,
                    controller: textEditingController,
                    prefixIcon: Icons.email_outlined,
                  ),
                  AppTextField(
                    hintText: "Password",
                    isPassword: true,
                    controller: textEditingController,
                    prefixIcon: Icons.lock_outline,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) {
                          setState(() {
                            rememberMe = val ?? false;
                          });
                        },
                      ),
                      Text(
                        "Remember me",
                        style: regularStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.black,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgetPasswordRoute');
                        },
                        child: Text('Forgot password?',
                            style: regularStyle(
                              fontSize: 14.sp,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color ??
                                      Colors.black,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  AppTextBtn(
                      buttonText: "Login",
                      textStyle: semiBoldStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  SizedBox(
                    height: 30.h,
                  ),
                  DividerWithText(
                    text: "Or continue with",
                    lineColor: Colors.grey.shade400,
                    textStyle: regularStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color ??
                          Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialAuthBtn( assetPath: 'assets/images/google.jpg',onTap: (){},),
                      SizedBox(width: 25.w),
                      SocialAuthBtn( assetPath: 'assets/images/facebook.jpg', onTap: () {
                        // Facebook sign in
                      }),
                       SizedBox(width: 25.w),
                      SocialAuthBtn(assetPath: 'assets/images/apple.jpg', onTap: () {
                        // Apple sign in
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: regularStyle(fontSize: 16.sp, color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign up',
                            style: semiBoldStyle(
                              fontSize: 16.sp,
                              color: ColorManager.brown,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushNamed(Routes.signUpRoute);
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
}
