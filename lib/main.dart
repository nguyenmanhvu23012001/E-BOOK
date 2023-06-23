import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:youtube_ecommerce/admin/dashboard.dart';
import 'package:youtube_ecommerce/admin/provider/user_provider.dart';
import 'package:youtube_ecommerce/constants/theme.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:youtube_ecommerce/firebase_helper/firebase_options/firebase_options.dart';
import 'package:youtube_ecommerce/provider/app_provider.dart';
import 'package:youtube_ecommerce/screens/auth_ui/welcome/welcome.dart';
import 'package:youtube_ecommerce/screens/custom_bottom_bar/custom_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Stripe.publishableKey =
  "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create:(context) => AppProvider(),),
        ChangeNotifierProvider<UserProvider>(create:(context) => UserProvider(), ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-book',
        theme: themeData,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if(snapshot.data?.email! =="admin@gmail.com"){
                return DashBoard();
              }
              return CustomBottomBar();
            }
            return const Welcome();
          },
        ),
      ),
    );
  }
}
