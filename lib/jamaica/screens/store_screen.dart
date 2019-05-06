import 'package:flutter/material.dart';
import 'package:maui/util/accessories_data.dart';
import 'package:maui/jamaica/widgets/store.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var accessories = StateContainer.of(context).state.userProfile.accessories;
    return Scaffold(
        appBar: AppBar(
          title: Text('Store'),
        ),
        body: Store(list));
  }
}
