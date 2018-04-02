import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("user_${user.id}.jpg");
    StorageUploadTask uploadTask = ref.put(new File(user.image));
    Uri downloadUrl = (await uploadTask.future).downloadUrl;

    final reference = FirebaseDatabase.instance.reference().child('users');
    reference.push().set({
      'id': user.id,
      'name': user.name,
      'image': downloadUrl.toString()
    });
    return await userDao.insert(user);
  }

  Future<int> delete(int id) async {
    return await userDao.delete(id);
  }

  Future<int> update(User user) async {
    return await userDao.update(user);
  }
}