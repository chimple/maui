import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/dao/user_dao.dart';

class UserRepo {
  static final UserDao userDao = new UserDao();

  const UserRepo();

  Future<User> getUser(String id) async {
      return await userDao.getUser(id);
  }

  Future<List<User>> getUsers() async {
    return await userDao.getUsers();
  }

  Future<User> insert(User user) async {
    return await userDao.insert(user);
  }

  Future<int> delete(int id) async {
    return await userDao.delete(id);
  }

  Future<int> update(User user) async {
    return await userDao.update(user);
  }
}