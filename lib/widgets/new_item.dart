import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:test_tapped/other/data_models.dart';
import 'package:test_tapped/other/styles.dart';

class NewItem extends StatelessWidget {
  final Book? book;

  NewItem({
    Key? key,
    this.book,
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
                child: book == null
                    ? Container(
                        color: Style.lightGreyColor.withOpacity(0.5),
                        width: itemHeight * 0.75,
                        height: itemHeight,
                      )
                    : Image.network(
                        book!.photoUrl,
                        fit: BoxFit.cover,
                        width: itemHeight * 0.75,
                        height: itemHeight,
                        // show the colored form while loading the item
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
                          book == null ? "loading …" : DateFormat('dd MMM yyyy').format(book!.addedTime).toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Style.getBookSubtitleTextStyle(date: true),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: itemHeight * 0.4,
              width: itemHeight * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(itemHeight * 0.1),
                border: Border.all(color: Style.lightGreyColor_1, width: Style.blockW * 0.06),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/bell_icon.svg",
                  height: itemHeight * 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
