import 'package:flutter/material.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/widgets/continue_item.dart';

import '../other/data_models.dart';

class SearchItem extends StatelessWidget {
  final Book book;

  const SearchItem({
    Key? key,
    required this.book,
  }) : super(key: key);

  static final double itemHeight = ContinueItem.itemHeight * 0.8;

  String title2seed(String s) => s.codeUnits.join('');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Style.screenHorizontalPadding,
          vertical: Style.screenHorizontalPadding * 0.5,
        ),
        height: itemHeight + Style.screenHorizontalPadding * 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(itemHeight * 0.1),
                child: Image.network(
                  book.photoUrl, // new title = new image
                  fit: BoxFit.cover,
                  width: itemHeight * 54 / 80,
                  height: itemHeight,
                  // show the colored form while loading the item
                  frameBuilder: (ctx, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedSwitcher(
                      duration: Style.standardAnimationDuration,
                      child: frame == null
                          ? Container(
                              color: Style.lightGreyColor.withOpacity(0.5),
                              width: itemHeight * 54 / 80,
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
                      book.title,
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
                      book.subtitle,
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
