import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_ecommerce/constants/constants.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';

import '../../widgets/primary_button/primary_button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isShowPassword = true;
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Đổi mật khẩu",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextFormField(
            controller: newpassword,
            obscureText: isShowPassword,
            decoration: InputDecoration(
              hintText: "Mật khẩu mới",
              prefixIcon: const Icon(
                Icons.password_sharp,
              ),
              suffixIcon: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isShowPassword = !isShowPassword;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  )),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: confirmpassword,
            obscureText: isShowPassword,
            decoration: const InputDecoration(
              hintText: "Xác nhận mật khẩu",
              prefixIcon: Icon(
                Icons.password_sharp,
              ),
             
            ),
          ),
          const SizedBox(
            height: 36.0,
          ),
          PrimaryButton(
            title: "Thay đổi",
            onPressed: () async {
              if (newpassword.text.isEmpty) {
                showMessage("Mật khẩu mới đang trống");
              } else if (confirmpassword.text.isEmpty) {
                showMessage("Mật khẩu xác nhận đang trống");
              } else if (confirmpassword.text == newpassword.text) {
                FirebaseAuthHelper.instance
                    .changePassword(newpassword.text, context);
              } else {
                showMessage("Mật khẩu không khớp");
              }
            },
          ),
        ],
      ),
    );
  }
}
