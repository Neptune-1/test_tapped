import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_tapped/other/books_service.dart';
import 'package:test_tapped/other/data_models.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/widgets/bottom_bar.dart';
import 'package:test_tapped/widgets/continue_item.dart';
import 'package:test_tapped/widgets/lazy_list.dart';
import 'package:test_tapped/widgets/new_item.dart';
import 'package:test_tapped/widgets/search_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StreamController<Key?> chosenItemsNumberSteamController = StreamController<Key?>();
  late final Stream<Key?> chosenItemsNumberStream;
  final SearchFieldController searchFieldController = SearchFieldController();

  @override
  void initState() {
    BookService.init();
    chosenItemsNumberStream = chosenItemsNumberSteamController.stream.asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    chosenItemsNumberSteamController.close();
    super.dispose();
  }

  // function to close keyboard, search overlay, and clear choice of continue item
  void clearScreen() {
    chosenItemsNumberSteamController.add(null);
    searchFieldController.hide();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<List<Object>> getContinueItems({int startNum = 0}) async {
    final response = await BookService.getContinueBooksBatch(startNum: startNum);
    final books = response[0] as List<Book>;
    final end = response[1] as bool;
    return [
      books
          .map(
            (book) => ContinueItem(
              key: UniqueKey(),
              book: book,
              chosenStream: chosenItemsNumberStream,
              chosenStreamController: chosenItemsNumberSteamController,
            ),
          )
          .toList()
          .cast<Widget>(),
      end
    ];
  }

  Future<List<Object>> getNewItems({int startNum = 0}) async {
    final response = await BookService.getNewItems(startNum: startNum);
    final books = response[0] as List<Book>;
    final end = response[1] as bool;

    return [
      books
          .map(
            (book) => NewItem(
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
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      body: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: clearScreen,
          child: Stack(
            children: [
              LazyList(
                padding: EdgeInsets.only(
                  top: Style.blockH * 2.7,
                  bottom: Style.blockH * 2,
                ),
                startItems: [
                  Container(
                    height: Style.blockH * 0.6,
                    padding: EdgeInsets.only(left: Style.screenHorizontalPadding),
                    child: Text(
                      "Continue",
                      style: Style.getTitleTextStyle(),
                    ),
                  ),
                  SizedBox(
                    height: Style.blockH * 0.3,
                  ),
                  SizedBox(
                    // height of ContinueWidget + spare space
                    height: ContinueItem.itemHeight + Style.blockH * 1.7,
                    child: LazyList(
                      loadItems: getContinueItems,
                      scrollDirection: Axis.horizontal,
                      loadingItem: const ContinueItem(),
                      padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding),
                      divider: SizedBox(
                        width: Style.screenHorizontalPadding,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Style.screenHorizontalPadding),
                    child: Text(
                      "New",
                      style: Style.getTitleTextStyle(),
                    ),
                  ),
                ],
                loadItems: getNewItems,
                loadingItem: NewItem(),
                divider: Container(
                  padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding),
                  height: 1.5,
                  child: Divider(
                    thickness: 1.5,
                    color: Style.dividerColor,
                  ),
                ),
              ),
              SearchField(
                controller: searchFieldController,
              ),
              const Positioned(
                bottom: 0,
                child: BottomBar(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
