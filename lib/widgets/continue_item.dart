import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_tapped/other/styles.dart';

class ContinueItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Stream<Key?> chosenStream;
  final StreamController<Key?> chosenStreamController;

  ContinueItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.chosenStream,
    required this.chosenStreamController,
  }) : super(key: key);

  final double itemWidth = (Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3; // _[item]_[item]_[item]_

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: chosenStream,
            builder: (context, snapshot) => AnimatedContainer(
              height: snapshot.data == key ? Style.blockH * 0.1 : 0,
              duration: Style.fastAnimationDuration,
            ),
          ),
          SizedBox(
            height: itemWidth,
            width: itemWidth,
            child: Stack(
              children: [
                ClipOval(
                  child: Image.network(
                    "https://picsum.photos/seed/$key/200",
                    fit: BoxFit.cover,
                    width: itemWidth,
                    height: itemWidth,
                    frameBuilder: (ctx, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) return child;
                      return AnimatedSwitcher(
                        duration: Style.standardAnimationDuration,
                        child: frame == null ? Container(color: Style.lightGreyColor.withOpacity(0.5)) : child,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      HapticFeedback.heavyImpact();
                      chosenStreamController.add(key);
                    },
                    child: SvgPicture.asset(
                      "assets/play_btn.svg",
                      width: itemWidth * 0.4,
                      height: itemWidth * 0.4,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: Style.blockH * 0.2,
          ),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: Style.getBookTitleTextStyle(),
            ),
          ),
          SizedBox(
            height: Style.blockH * 0.1,
          ),
          Flexible(
            child: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: Style.getBookSubtitleTextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
