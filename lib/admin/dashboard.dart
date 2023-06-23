import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_ecommerce/admin/category_admin.dart';
import 'package:youtube_ecommerce/admin/product_admin.dart';
import 'package:youtube_ecommerce/admin/provider/user_provider.dart';
import 'package:youtube_ecommerce/admin/style/colors.dart';
import 'package:youtube_ecommerce/admin/style/style.dart';
import 'package:youtube_ecommerce/admin/user_admin.dart';
import 'package:youtube_ecommerce/constants/routes.dart';
import 'component/appBarActionItems.dart';
import 'component/barChart.dart';
import 'component/header.dart';
import 'component/historyTable.dart';
import 'component/infoCard.dart';
import 'component/paymentDetailList.dart';
import 'component/sideMenu.dart';
import 'config/responsive.dart';
import 'config/size_config.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider  provider = Provider.of<UserProvider>(context,listen: false);
    provider.init();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) =>
          Scaffold(
            key: _drawerKey,
            drawer: SizedBox(width: 100, child: SideMenu()),
            appBar: !Responsive.isDesktop(context)
                ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    _drawerKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu, color: AppColors.black)),
              actions: [
                AppBarActionItems(),
              ],
            )
                : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      flex: 1,
                      child: SideMenu(),
                    ),
                  Expanded(
                      flex: 10,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Header(),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 4,
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth,
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 20,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    InfoCard(
                                        icon: Icon(Icons.book),
                                        destination: UserAdmin(),
                                        label: 'Người dùng',
                                        amount: userProvider.getUserModelList.length.toString()),
                                    InfoCard(
                                        icon: Icon(Icons.production_quantity_limits),
                                        destination: DashBoard(),
                                        label: 'Đơn hàng',
                                        amount: '40'),
                                    InfoCard(
                                        icon: Icon(Icons.category_rounded),
                                        destination: Category(),
                                        label: 'Thể loại',
                                        amount: '7'),
                                    InfoCard(
                                        icon: Icon(Icons.supervised_user_circle_sharp),
                                        destination: Product(),
                                        label: 'Sản phẩm',
                                        amount: userProvider.getProduct.length.toString()),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical * 4,
                              ),
                              Center(
                                child: ElevatedButton (
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: Text("Log out"),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
    );
  }

}



