import 'package:flutter/material.dart';
import 'package:nazra/peresentation/resources/color_manager.dart';
import 'package:nazra/peresentation/resources/styles_manager.dart';
import 'package:nazra/peresentation/resources/value_manager.dart';
import 'package:nazra/peresentation/widgets/app_text_btn.dart';
import 'package:nazra/peresentation/widgets/app_text_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/confirm_mail.png"),
            SizedBox(height: 50,),
            Text(
              "Enter your Email",
              style: semiBoldStyle(fontSize: 24, color: Colors.black),
            ),SizedBox(height: 10,),
            Text(
              "Enter your email address to receive a reset code.",
              style: regularStyle(fontSize: 12, color: ColorManager.gray),
            ),
            SizedBox(height: 35,),
            AppTextField(
              controller: textEditingController,
              hintText: "Email",
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 20,),
            AppTextBtn(
                buttonText: "Send Code",
                textStyle: semiBoldStyle(fontSize: 18, color: Colors.white),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
