import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:maui/models/user.dart';
import 'package:maui/tables/user_table.dart';

class UserRepo {
  static final UserTable userTable = new UserTable();

  const UserRepo();

  Future<User> getUser(String id) async {
      return await userTable.getUser(id);
  }

  Future<List<User>> getUsers() async {
    return await userTable.getUsers();
  }

  Future<User> insert(User user) async {
    return await userTable.insert(user);
  }

  Future<int> delete(int id) async {
    return await userTable.delete(id);
  }

  Future<int> update(User user) async {
    return await userTable.update(user);
  }
}