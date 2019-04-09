import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/store.dart';
import 'package:maui/jamaica/models/accessories_data.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accessories = StateContainer.of(context).state.userProfile.accessories;
    return Scaffold(
        appBar: AppBar(
          title: Text('Store'),
        ),
        body: Store(accessories, list));
  }
}
