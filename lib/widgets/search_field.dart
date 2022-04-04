import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/widgets/lazy_list.dart';
import 'package:test_tapped/widgets/search_item.dart';

import '../other/books_service.dart';
import '../other/data_models.dart';

class SearchFieldController {
  late void Function() hide;
}

class SearchField extends StatefulWidget {
  final SearchFieldController controller;

  const SearchField({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  final TextEditingController searchFieldTextController = TextEditingController();
  final FocusNode searchFieldFocusNode = FocusNode();
  bool showOverlay = false;
  LazyListController controller = LazyListController();
  final StreamController<int> searchItemsNumberController = StreamController<int>();
  late final Stream<int> searchItemsNumberStream;

  @override
  void initState() {
    super.initState();
    searchItemsNumberStream = searchItemsNumberController.stream;

    widget.controller.hide = hide;
    searchFieldFocusNode.addListener(() {
      setState(() {
        showOverlay = searchFieldTextController.text.isNotEmpty && searchFieldFocusNode.hasPrimaryFocus;
      });
    });
  }

  @override
  void dispose() {
    searchItemsNumberController.close();
    super.dispose();
  }

  void hide() => setState(() => showOverlay = false);

  Future<List<Object>> getSearchItems({int startNum = 0}) async {
    final response = await BookService.getSearchItems(searchFieldTextController.text, startNum: startNum);
    final books = response[0] as List<Book>;
    final end = response[1] as bool;
    return [
      books
          .map(
            (book) => SearchItem(
              book: book,
            ),
          )
          .toList()
          .cast<Widget>(),
      end
    ];
  }

  @override
  Widget build(BuildContext context) {
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
              color: Style.shadowColor.withOpacity(
                showOverlay ? 0.3 : 0.1,
              ), // make the shadow darker if the user is searching
            ),
          ],
        ),
        child: Material(
          child: Ink(
            color: Style.backgroundColor,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: searchFieldFocusNode.requestFocus,
                  child: Container(
                    width: Style.blockW * 20,
                    height: Style.blockH * 1.3,
                    padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding * 1.3),
                    child: Center(
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              focusNode: searchFieldFocusNode,
                              controller: searchFieldTextController,
                              onChanged: (newPlaceStr) => setState(() {
                                showOverlay =
                                    searchFieldTextController.text.isNotEmpty && searchFieldFocusNode.hasPrimaryFocus;
                              }),
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
                StreamBuilder<int>(
                  stream: searchItemsNumberStream,
                  builder: (context, snapshot) {
                    return AnimatedContainer(
                      // number of items * item height + padding if search result is not empty
                      height: showOverlay
                          ? min(snapshot.data ?? 0, 3) * (SearchItem.itemHeight + Style.screenHorizontalPadding) +
                              (showOverlay ? Style.blockH * 0.7 : 0)
                          : 0,
                      duration: Style.fastAnimationDuration,
                      child: AnimatedSwitcher(
                        duration: Style.standardAnimationDuration,
                        child: showOverlay
                            ? LazyList(
                                key: Key(searchFieldTextController.text),
                                loadItems: getSearchItems,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: Style.blockH * 0.7),
                                divider: SizedBox(
                                  height: 1.5,
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Style.dividerColor,
                                  ),
                                ),
                                controller: controller,
                                searchItemsNumberController: searchItemsNumberController,
                                showDividerBeforeLoadingItem: false,
                                noItemsItem: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding*1.3),
                                    child: Text("No items found", style: Style.getSearchTextStyle(hint: true))),
                              )
                            : Container(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
