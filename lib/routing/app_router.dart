import 'package:flutter/material.dart';
import 'package:nazra/peresentation/notifications/notification_screen.dart';
import 'package:nazra/peresentation/Auth/login/login_screen.dart';
import 'package:nazra/peresentation/Auth/signUp/signup_screen.dart';
import 'package:nazra/peresentation/complains/add_complaint_screen.dart';
import 'package:nazra/peresentation/forget%20Password/new_password_screen.dart';
import 'package:nazra/peresentation/forget%20Password/otp_screen.dart';
import 'package:nazra/peresentation/onBoarding/onboarding_screen.dart';
import 'package:nazra/routing/routes.dart';

import '../peresentation/Home/home_screen_state.dart';
import '../peresentation/admin/home/admin_home_base_screen.dart';
import '../peresentation/forget Password/forget_password_screen.dart';

class AppRouter {
  AppRouter();
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.homeScreenState:
        return MaterialPageRoute(builder: (_) => const HomeScreenState());
      case Routes.addComplaintScreen:
        return MaterialPageRoute(builder: (_) => const AddComplaintScreen());
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
      case Routes.notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.adminHomeScreen:
        return MaterialPageRoute(builder: (_) => const AdminHomeBaseScreen());
      default:
        return null;
    }
  }
}
