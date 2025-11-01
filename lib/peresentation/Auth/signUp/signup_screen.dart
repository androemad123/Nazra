import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../app/bloc/auth/auth_bloc.dart';
import '../../../app/bloc/auth/auth_event.dart';
import '../../../app/bloc/auth/auth_state.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthSignUpRequested(
        email: email,
        password: password,
        displayName: name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.loading:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Creating account...")),
            );
            break;

          case AuthStatus.authenticated:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account created successfully!")),
            );
            Navigator.pushReplacementNamed(context, Routes.homeScreenState);
            break;

          case AuthStatus.failure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Signup failed')),
            );
            break;

          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.isDarkMode
                    ? [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.surface,
                ]
                    : [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.all(AppPadding.p18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),

                              // Header
                              Row(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        ColorManager.brown,
                                        ColorManager.brown,
                                        ColorManager.cream,
                                      ],
                                    ).createShader(bounds),
                                    child: Text(
                                      "Create",
                                      style: semiBoldStyle(
                                        fontSize: 40.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "your",
                                    style: semiBoldStyle(
                                      fontSize: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Account",
                                style: semiBoldStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              ),

                              // Fields
                              AppTextField(
                                hintText: "Full name",
                                isPassword: false,
                                controller: _nameController,
                                prefixIcon: Icons.person_3_outlined,
                              ),
                              AppTextField(
                                hintText: "Email",
                                isPassword: false,
                                controller: _emailController,
                                prefixIcon: Icons.email_outlined,
                              ),
                              AppTextField(
                                hintText: "Phone number",
                                isPassword: false,
                                controller: _phoneController,
                                prefixIcon: Icons.phone_iphone_outlined,
                              ),
                              AppTextField(
                                hintText: "Password",
                                isPassword: true,
                                controller: _passwordController,
                                prefixIcon: Icons.lock_outline,
                              ),
                              AppTextField(
                                hintText: "Confirm password",
                                isPassword: true,
                                controller: _confirmPasswordController,
                                prefixIcon: Icons.lock_outline,
                              ),

                              const SizedBox(height: 15),

                              AppTextBtn(
                                buttonText:
                                isLoading ? "Creating Account..." : "Sign Up",
                                textStyle: semiBoldStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                onPressed: isLoading
                                    ? (){}
                                    : () => _onSignupPressed(context),
                              ),

                              const SizedBox(height: 20),

                              DividerWithText(
                                text: "Or sign up with",
                                lineColor: Colors.grey.shade400,
                                textStyle: regularStyle(
                                  fontSize: 14,
                                  color:
                                  Theme.of(context).textTheme.bodyMedium?.color ??
                                      Colors.black,
                                ),
                              ),

                              const SizedBox(height: 30),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SocialAuthBtn(
                                    assetPath: 'assets/images/google.jpg',
                                    onTap: () {
                                      // TODO: Add Google sign-in
                                    },
                                  ),
                                  const SizedBox(width: 25),
                                  SocialAuthBtn(
                                    assetPath: 'assets/images/facebook.jpg',
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 25),
                                  SocialAuthBtn(
                                    assetPath: 'assets/images/apple.jpg',
                                    onTap: () {},
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style: regularStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign in',
                                        style: semiBoldStyle(
                                          fontSize: 16,
                                          color: ColorManager.brown,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context)
                                                .pushNamed(Routes.loginRoute);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
