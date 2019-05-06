import 'package:flutter/material.dart';
import 'package:maui/util/collected_item_data.dart';
import 'package:maui/widgets/collected_item_screen.dart';
import 'package:maui/state/app_state_container.dart';

class Collected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var items = AppStateContainer.of(context).userProfile.items;

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
