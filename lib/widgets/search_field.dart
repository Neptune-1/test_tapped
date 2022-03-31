import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/other/utils.dart';
import 'package:test_tapped/widgets/search_item.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchFieldTextController;
  final FocusNode searchFieldFocusNode;
  final StreamController<bool> showSearchResults;

  const SearchField({
    Key? key,
    required this.searchFieldTextController,
    required this.searchFieldFocusNode,
    required this.showSearchResults,
  }) : super(key: key);
  static const int numberOfSearchItems = 3;

  Widget getSearchItems({required String searchString}) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: Style.blockH * 0.5),
      children: List.generate(
        // Fill with n items and n-1 dividers
        (numberOfSearchItems * 2 - 1),
        (index) => index % 2 == 1
            ? const SizedBox(
                height: 1.5,
                child: Divider(
                  thickness: 1.5,
                  color: Style.dividerColor,
                ),
              )
            : SearchItem(
                key: Key(index.toString()),
                title: searchString.capitalize() + ' and other stories ' + ['I', 'II', 'III'][index ~/ 2],
                subtitle: 'A lot of authors',
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: showSearchResults.stream,
      builder: (context, snapshot) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: Style.blockH * 2.2),
          child: Container(
            width: Style.blockW * 20,
            padding: EdgeInsets.only(
              top: Style.blockH * 0.8,
            ),
            decoration: BoxDecoration(
              color: Style.backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: Style.shadowColor.withOpacity((snapshot.data ?? false) ? 0.3 : 0.1),
                ),
              ],
            ),
            child: Material(
              child: Ink(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Style.blockW * 20,
                      height: Style.blockH * 1.3,
                      padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding * 2),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: searchFieldFocusNode.requestFocus,
                        child: Center(
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  focusNode: searchFieldFocusNode,
                                  controller: searchFieldTextController,
                                  onChanged: (newPlaceStr) => showSearchResults
                                      .add(newPlaceStr.isNotEmpty && searchFieldFocusNode.hasPrimaryFocus),
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.search,
                                  maxLines: 1,
                                  style: Style.getSearchTextStyle(),
                                  textAlign: TextAlign.left,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  decoration: InputDecoration(
                                    hintText: "Search for something",
                                    hintStyle: Style.getSearchTextStyle(hint: true),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Style.blockW,
                              ),
                              SvgPicture.asset(
                                "assets/search_icon.svg",
                                width: Style.blockH * 0.45,
                                height: Style.blockH * 0.45,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      height: (snapshot.data ?? false ? numberOfSearchItems : 0) *
                              ((Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3 * 0.8 +
                                  Style.screenHorizontalPadding * 0.5) +
                          (snapshot.data ?? false ? Style.blockH : 0),
                      duration: Style.standardAnimationDuration,
                      child: AnimatedSwitcher(
                        duration: Style.standardAnimationDuration,
                        child: snapshot.data ?? false
                            ? getSearchItems(searchString: searchFieldTextController.text)
                            : Container(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
