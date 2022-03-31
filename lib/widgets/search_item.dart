import 'package:flutter/material.dart';
import 'package:test_tapped/other/styles.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final String subtitle;

  SearchItem({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  // continue item width = new item height
  final double itemHeight = (Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3 * 0.8;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Style.screenHorizontalPadding,
          vertical: Style.screenHorizontalPadding * 0.25,
        ),
        height: itemHeight + Style.screenHorizontalPadding * 0.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(itemHeight * 0.1),
                child: Image.network(
                  "https://picsum.photos/seed/2$key/200",
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.blockW),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Style.blockW * 20 - (itemHeight * 0.75 + Style.screenHorizontalPadding * 4),
                    child: Text(
                      title,
                      maxLines: 1,
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
            ),
          ],
        ),
      ),
    );
  }
}
