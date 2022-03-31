import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:test_tapped/other/styles.dart';

class NewItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime addedTime;

  NewItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.addedTime,
  }) : super(key: key);

  // continue item width = new item height
  final double itemHeight = (Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Style.screenHorizontalPadding,
          vertical: Style.screenHorizontalPadding * 0.5,
        ),
        height: itemHeight + Style.screenHorizontalPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(itemHeight * 0.1),
                child: Image.network(
                  "https://picsum.photos/seed/1$key/200",
                  fit: BoxFit.cover,
                  width: itemHeight * 0.75,
                  height: itemHeight,
                  frameBuilder: (ctx, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedSwitcher(
                      duration: Style.standardAnimationDuration,
                      child: frame == null
                          ? Container(
                              color: Style.lightGreyColor.withOpacity(0.5),
                              width: itemHeight * 0.75,
                              height: itemHeight,
                            )
                          : child,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Style.blockW),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    SizedBox(
                      height: Style.blockH * 0.3,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/calendar_icon.svg",
                          height: Style.blockH * 0.5,
                        ),
                        SizedBox(
                          width: Style.blockW * 0.2,
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(addedTime).toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Style.getBookSubtitleTextStyle(date: true),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SvgPicture.asset(
              "assets/bell_icon.svg",
              height: itemHeight * 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
