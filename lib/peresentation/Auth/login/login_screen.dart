import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nazra/peresentation/resources/value_manager.dart';
import 'package:nazra/peresentation/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var key = GlobalKey();
  bool _obscureText = true;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.all(AppPadding.p18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome\n',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(fontSize: 40.sp),
                    ),
                    TextSpan(
                      text: 'Back',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontSize: 40.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Log in to continue improving your streets',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 30.h),
              AppTextField(
                label: 'Email or Username',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscureText,
                suffixIcon: Icons.visibility_outlined,
                onSuffixIconPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
