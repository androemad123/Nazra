import 'package:flutter/material.dart';
import 'package:nazra/peresentation/Auth/login/login_screen.dart';
import 'package:nazra/peresentation/Auth/signUp/signup_screen.dart';
import 'package:nazra/peresentation/Home/home.dart';
import 'package:nazra/peresentation/forget%20Password/new_password_screen.dart';
import 'package:nazra/peresentation/forget%20Password/otp_screen.dart';
import 'package:nazra/peresentation/onBoarding/onboarding_screen.dart';
import 'package:nazra/routing/routes.dart';

import '../peresentation/forget Password/forget_password_screen.dart';

class AppRouter {
  AppRouter();
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case Routes.otpScreenRoute:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case Routes.newPasswordRoute:
        return MaterialPageRoute(builder: (_) => const NewPasswordScreen());
      default:
        return null;
    }
  }
}
