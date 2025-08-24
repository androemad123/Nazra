import 'package:flutter/material.dart';
import 'package:nazra/peresentation/Auth/login/login_screen.dart';
import 'package:nazra/peresentation/Auth/signUp/signup_screen.dart';
import 'package:nazra/peresentation/Home/home.dart';
import 'package:nazra/peresentation/onBoarding/onboarding_screen.dart';
import 'package:nazra/routing/routes.dart';

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
      default:
        return null;
    }
  }
}
