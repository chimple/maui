import 'package:flutter/material.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchScreen extends StatefulWidget {
  @override
  SwitchScreenState createState() {
    return new SwitchScreenState();
  }
}

class SwitchScreenState extends State<SwitchScreen> {
  bool _isLoading = true;

  _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      User user = await UserRepo().getUser(userId);
      await AppStateContainer.of(context).setLoggedInUser(user);
      Navigator.of(context).pushReplacementNamed('/welcome');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: new SizedBox(
      width: 20.0,
      height: 20.0,
      child: new CircularProgressIndicator(),
    ));
  }
}
