import 'package:flutter/material.dart';
import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:nazra/peresentation/resources/value_manager.dart';

import '../../resources/color_manager.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.all(AppPadding.p18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome",
              style: boldStyle(
                fontSize: 40, color: Colors.transparent,
              ).copyWith(
                foreground: Paint()
                  ..shader =  LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment. topLeft,
                    colors: [
                      ColorManager.brown,
                      ColorManager.white,
                    ],
                  ).createShader(
                    Rect.fromLTWH(0, 0, 200, 70), // width/height of the text box
                  ),
              ),
            ),
            AppTextField(
              hintText: "hey this is testing ",
              isPassword: false,
              controller: textEditingController,
              prefixIcon: Icons.email,
            ),
            AppTextField(
              hintText: "hey this is testing ",
              isPassword: false,
              controller: textEditingController,
              prefixIcon: Icons.email,
            ),
          ],
        ),
      ),
    );
  }
}
