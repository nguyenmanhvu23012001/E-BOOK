import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_ecommerce/constants/routes.dart';
import '../config/responsive.dart';
import '../config/size_config.dart';
import '../style/colors.dart';
import '../style/style.dart';

class InfoCard extends StatelessWidget {
  final Icon icon;
  final String label;
  final String amount;
  final  Widget destination;


  InfoCard({required this.icon, required this.label, required this.amount,required this.destination});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination,));
      } ,
      child: Container(
        constraints: BoxConstraints(minWidth: Responsive.isDesktop(context) ? 200 : SizeConfig.screenWidth/2 - 40),
          padding: EdgeInsets.only(
              top: 20, bottom: 20, left: 20, right: Responsive.isMobile(context) ? 20 : 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: Row(children: [
                  icon,
                  SizedBox(width: 20,),
                  PrimaryText(
                      text: amount,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      size: 16),

                ],),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              PrimaryText(
                  text: label,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  size: 16),

              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
            ],
          ),),
    );
  }
}