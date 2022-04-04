import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_tapped/other/data_models.dart';
import 'package:test_tapped/other/styles.dart';

class ContinueItem extends StatelessWidget {
  final Book? book;
  final Stream<Key?>? chosenStream;
  final StreamController<Key?>? chosenStreamController;

  const ContinueItem({
    Key? key,
    this.book,
    this.chosenStream,
    this.chosenStreamController,
  }) : super(key: key);

  static final double itemWidth =
      (Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3; // due to  _[item]_[item]_[item]_
  static final double itemHeight = itemWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: itemWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          book == null
              ? Container()
              : StreamBuilder(
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
                  child: book == null
                      ? Container(color: Style.lightGreyColor.withOpacity(0.5))
                      : Image.network(
                          book!.photoUrl,
                          fit: BoxFit.cover,
                          width: itemWidth,
                          height: itemWidth,
                          // show the colored form while loading the item
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
                      if (book != null) chosenStreamController!.add(key);
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
              book == null ? "loading …" : book!.title,
              overflow: TextOverflow.ellipsis,
              style: Style.getBookTitleTextStyle(),
            ),
          ),
          SizedBox(
            height: Style.blockH * 0.1,
          ),
          Flexible(
            child: Text(
              book == null ? "loading …" : book!.subtitle,
              overflow: TextOverflow.ellipsis,
              style: Style.getBookSubtitleTextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
