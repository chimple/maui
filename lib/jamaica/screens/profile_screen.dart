import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/collected.dart';
import 'package:maui/loca.dart';
import 'package:maui/jamaica/widgets/progress.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorWeight: 5.0,
            labelColor: Colors.white,
            labelStyle: new TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
            tabs: [
              new Tab(
                text: Loca.of(context).progress,
              ),
              new Tab(text: Loca.of(context).collection),
            ],
          ),
        ),
        body: Stack(children: [
          Container(
            color: Colors.blueGrey,
          ),
          TabBarView(
            children: [
              Progress(),
              Collected(),
            ],
          ),
        ]),
      ),
    );
  }
}
