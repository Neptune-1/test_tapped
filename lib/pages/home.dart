import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_tapped/other/styles.dart';
import 'package:test_tapped/widgets/bottom_bar.dart';
import 'package:test_tapped/widgets/continue_item.dart';
import 'package:test_tapped/widgets/new_item.dart';
import 'package:test_tapped/widgets/search_field.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int numberOfContinueItems = 20;
  static const int numberOfNewItems = 20;
  final TextEditingController searchFieldTextController = TextEditingController();
  final FocusNode searchFieldFocusNode = FocusNode();
  final StreamController<Key?> chosenItemsNumberSteamController = StreamController<Key?>();
  final StreamController<bool> showSearchResults = StreamController<bool>();
  late final Stream<Key?> chosenItemsNumberStream;

  @override
  void initState() {
    chosenItemsNumberStream = chosenItemsNumberSteamController.stream.asBroadcastStream();
    searchFieldFocusNode.addListener(
      () => showSearchResults.add(searchFieldTextController.text.isNotEmpty && searchFieldFocusNode.hasPrimaryFocus),
    );
    super.initState();
  }

  @override
  void dispose() {
    chosenItemsNumberSteamController.close();
    super.dispose();
  }

  void clearScreen() {
    chosenItemsNumberSteamController.add(null);
    showSearchResults.add(false);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget getContinueItems() {
    return SizedBox(
      height: (Style.blockW * 20 - Style.screenHorizontalPadding * 4) / 3 + Style.blockH * 1.7,
      //height of ContinueWidget + spare space
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          // Fill with n items and n+1 spaces
          (numberOfContinueItems * 2 + 1),
          (index) => index % 2 == 0
              ? SizedBox(
                  width: Style.screenHorizontalPadding,
                )
              : ContinueItem(
                  key: Key(index.toString()),
                  title: 'My Book Cover',
                  subtitle: 'A lot of authors',
                  chosenStream: chosenItemsNumberStream,
                  chosenStreamController: chosenItemsNumberSteamController,
                ),
        ),
      ),
    );
  }

  List<Widget> getNewItems() {
    return List.generate(
      // Fill with n items and n-1 dividers
      (numberOfNewItems * 2 - 1),
      (index) => index % 2 == 1
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Style.screenHorizontalPadding),
              child: const Divider(
                height: 1.5,
                thickness: 1.5,
                color: Style.dividerColor,
              ),
            )
          : NewItem(
              key: Key(index.toString()),
              title: 'My Book Cover',
              subtitle: 'A lot of authors',
              addedTime: DateTime.utc(
                2021,
                Random().nextInt(11) + 1,
                Random().nextInt(27) + 1,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      body: GestureDetector(
        onTap: clearScreen,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(
                top: Style.blockH * 2.7,
                bottom: Style.blockH * 2,
              ),
              children: [
                Container(
                  height: Style.blockH * 0.6,
                  padding: EdgeInsets.only(left: Style.screenHorizontalPadding),
                  child: Text(
                    "Continue",
                    style: Style.getTitleTextStyle(),
                  ),
                ),
                SizedBox(
                  height: Style.blockH * 0.2,
                ),
                getContinueItems(),
                Container(
                  height: Style.blockH * 0.6,
                  padding: EdgeInsets.only(left: Style.screenHorizontalPadding),
                  child: Text(
                    "New",
                    style: Style.getTitleTextStyle(),
                  ),
                ),
                ...getNewItems()
              ],
            ),
            SearchField(
              searchFieldTextController: searchFieldTextController,
              searchFieldFocusNode: searchFieldFocusNode,
              showSearchResults: showSearchResults,
            ),
            const Positioned(
              bottom: 0,
              child: BottomBar(),
            )
          ],
        ),
      ),
    );
  }
}
