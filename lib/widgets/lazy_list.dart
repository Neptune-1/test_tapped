import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_tapped/other/styles.dart';

class LazyListController {}

class LazyList extends StatefulWidget {
  final Future<List<Object>> Function({int startNum}) loadItems;
  final Axis scrollDirection;
  final Widget? loadingItem;
  final List<Widget> startItems;
  final EdgeInsets padding;
  final Widget divider;
  final bool shrinkWrap;
  final LazyListController? controller;
  final StreamController<int>? searchItemsNumberController;
  final bool showDividerBeforeLoadingItem;
  final Widget noItemsItem;

  const LazyList({
    Key? key,
    required this.loadItems,
    this.loadingItem,
    this.controller,
    this.searchItemsNumberController,
    this.divider = const SizedBox(),
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.startItems = const [],
    this.padding = EdgeInsets.zero,
    this.showDividerBeforeLoadingItem = true,
    this.noItemsItem = const SizedBox(),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LazyListState();
}

class LazyListState extends State<LazyList> with AutomaticKeepAliveClientMixin {
  List<Widget> items = [];
  bool isLoading = true;
  bool end = false;

  @override
  void initState() {
    super.initState();
    items = [...widget.startItems];
    refresh();
  }

  void clear() {
    setState(() {
      items = [];
    });
  }

  Future<void> refresh() async {
    isLoading = true;
    final response = await widget.loadItems(startNum: items.length - widget.startItems.length);
    final List<Widget> newItems = response[0] as List<Widget>;
    final bool end = response[1] as bool;
    items.addAll(newItems);

    if (widget.searchItemsNumberController != null) widget.searchItemsNumberController!.add(items.length);
    isLoading = false;
    this.end = end;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: items.length + 1,
      scrollDirection: widget.scrollDirection,
      itemBuilder: (context, index) {
        if(end && items.isEmpty) return widget.noItemsItem;
        if (index == items.length - 1 && !isLoading && !end) refresh();

        return index == items.length
            ? (end
                ? const SizedBox()
                : (widget.loadingItem ??
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(Style.blockH * 0.1),
                        width: Style.blockH * 0.6,
                        height: Style.blockH * 0.6,
                        child: CircularProgressIndicator(
                          color: Style.primaryColor,
                          strokeWidth: Style.blockW * 0.15,
                        ),
                      ),
                    )))
            : items[index];
      },
      separatorBuilder: (BuildContext context, int index) => (index < widget.startItems.length) ||
              (index == items.length - 1 && end) ||
              (index == items.length - 1 && !widget.showDividerBeforeLoadingItem)
          ? Container()
          : widget.divider,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
