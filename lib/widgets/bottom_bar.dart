import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_tapped/other/styles.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Style.blockW * 0.5),
        color: Style.bottomBarColor,
      ),
      height: Style.blockH * 1.5,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: Style.blockW * 20,
            height: Style.blockH * 1.5,
            padding: EdgeInsets.fromLTRB(
              Style.blockW,
              Style.blockH * 0.2,
              Style.blockW * 2,
              Style.blockH * 0.2,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                    padding: EdgeInsets.symmetric(horizontal: Style.blockH * 0.35, vertical: Style.blockH * 0.2),
                    decoration: BoxDecoration(
                        color: Style.backgroundColor, borderRadius: BorderRadius.circular(Style.blockH * 0.3),),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/bottom_0.svg",
                          height: Style.blockH * 0.6,
                          width: Style.blockH * 0.6,
                        ),
                        SizedBox(width:  Style.blockH * 0.2,),
                        Text("Home", style: Style.getBottomBarTextStyle())
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/bottom_1.svg",
                    height: Style.blockH * 0.6,
                  ),
                  SvgPicture.asset(
                    "assets/bottom_2.svg",
                    height: Style.blockH * 0.6,
                  ),
                  SvgPicture.asset(
                    "assets/bottom_3.svg",
                    height: Style.blockH * 0.6,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
