import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_ecommerce/constants/routes.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:youtube_ecommerce/screens/about_us/about_us.dart';
import 'package:youtube_ecommerce/screens/auth_ui/login/login.dart';
import 'package:youtube_ecommerce/screens/change_password/change_password.dart';
import 'package:youtube_ecommerce/screens/edit_profile/edit_profile.dart';
import 'package:youtube_ecommerce/screens/favourite_screen/favourite_screen.dart';
import 'package:youtube_ecommerce/screens/order_screen/order_screen.dart';
import 'package:youtube_ecommerce/widgets/primary_button/primary_button.dart';

import '../../provider/app_provider.dart';
<<<<<<< HEAD
import '../auth_ui/login/login.dart';
=======
import '../auth_ui/welcome/welcome.dart';
>>>>>>> 0495526804fd2d01f6d6abe807582eb9b14de489

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Tài khoản",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                appProvider.getUserInformation.image == null
                    ? const Icon(
                        Icons.person_outline,
                        size: 100,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(appProvider.getUserInformation.image!),
                        radius: 60,
                      ),
                Text(
                  appProvider.getUserInformation.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  appProvider.getUserInformation.email,
                ),
                SizedBox(height: 7,),
                SizedBox(
                  height: 35,
                  width: 130,
                  child: PrimaryButton(
                    title: "Chỉnh sửa tài khoản",
                    onPressed: () {
                      Routes.instance
                          .push(widget: const EditProfile(), context: context);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const OrderScreen(), context: context);
                  },
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text("Đơn hàng của bạn"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance.push(
                        widget: const FavouriteScreen(), context: context);
                  },
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text("Yêu thích"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const AboutUs(), context: context);
                  },
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Thông tin về E-book"),
                ),
                ListTile(
                  onTap: () {
                    Routes.instance
                        .push(widget: const ChangePassword(), context: context);
                  },
                  leading: const Icon(Icons.change_circle_outlined),
                  title: const Text("Đổi mật khẩu"),
                ),
                ListTile(
                  onTap: ()async {
<<<<<<< HEAD
                     await FirebaseAuth.instance.signOut();
=======
                    try {
                     FirebaseAuthHelper.instance.signOut();
                     Routes.instance.pushAndRemoveUntil(widget:const Welcome(), context: context);
                    } catch (e) {
                      print('Error signing out: $e');
                    }
                    setState(() {});
>>>>>>> 0495526804fd2d01f6d6abe807582eb9b14de489
                  },
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Đăng xuất"),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                const Text("Phiên bản 1.0.0")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
