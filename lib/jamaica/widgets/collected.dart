import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/collected_item_screen.dart';
import 'package:maui/jamaica/models/collected_item_data.dart';

class Collected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var items = StateContainer.of(context).state.userProfile.items;

    return Scaffold(
        appBar: AppBar(
          title: Text('Store'),
        ),
        body: CollectedItemScreen(
          staticItems: list,
          itemsValue: items,
        ));
  }
}
