import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:maui/db/dao/tile_dao.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:meta/meta.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UserRepo {
  static final UserDao userDao = new UserDao();

  const UserRepo();

  Future<User> getUser(String id) async {
    return await userDao.getUser(id);
  }

  Future<List<User>> getUsers() async {
    return await userDao.getUsers();
  }

  Future<List<User>> getRemoteUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    return await userDao.getUsersOtherThanDeviceId(deviceId);
  }

  Future<User> insertOrUpdateRemoteUser(
      String userId, String deviceId, String txnText) async {
    print('UserRepo.insertOrUpdateRemoteUser: $userId $deviceId');
    final userInfo = txnText.split('*');
    String imagePath;
    if (userInfo.length == 3) {
      String base64Image = userInfo.last;
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      List<int> memoryImage;
      try {
        memoryImage = base64.decode(base64Image);
      } catch (e) {
        print(e);
      }
      imagePath = join(documentsDirectory.path, '$userId.png');
      await new File(imagePath).writeAsBytes(memoryImage);
    }
    User user = await userDao.getUser(userId);
    if (user == null) {
      await userDao.insert(User(
          id: userId,
          deviceId: deviceId,
          image: imagePath,
          name: userInfo.length > 1 ? userInfo[0] : null,
          color:
              userInfo.length > 2 ? int.tryParse(userInfo[1], radix: 16) : null,
          currentLessonId: 1));
    }
  }

  Future<List<User>> getLocalUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    return await userDao.getUsersByDeviceId(deviceId);
  }

  Future<User> insertLocalUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('deviceId');
    final loggedInUserId = prefs.getString('userId');
    user.deviceId = deviceId;
    var config = File(user.image);
    var contents = await config.readAsBytes();
    var enc = user.name +
        '*' +
        user.color.toRadixString(16) +
        '*' +
        base64.encode(contents);
    try {
      p2p.addUser(user.id, deviceId, enc);
    } on PlatformException {
      print('Flores: Failed addUser');
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }

    final tileRepo = TileRepo();
    var id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[128, 150, 180, 200, 220, 240, 260, 280, 300, 340],"y":[256, 340, 220, 160, 170, 180, 200, 230, 300, 340],"c":[1,1,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[36,14,58,75,50,54,79,103,94,61,66,110,128,137,157,207,223,186,171,177,225,201,163,216,271,325,376,419,452,479,493,495,482,457,421,439,459,468,463,442,407,368,361,359,345,309,264,225,200,182,146,99,63],"y":[86,129,153,192,240,292,341,388,440,473,503,483,431,379,330,301,330,348,382,429,453,474,498,502,503,502,487,455,412,364,315,260,209,160,129,171,218,269,321,367,407,436,388,339,288,248,217,181,135,84,44,9,41],"c":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[243,95,3,3,96,244,392,483,483,390],"y":[0,48,174,331,457,505,457,331,173,47],"c":[0,0,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[86,274,311,122,197,160,238,88,289,79,313,54,334,40,346,38,359,8,372,32,344,46,338,51,329,66,314,91,291,36,138,259,0,70,224,178,315,121,13,268,335,107,41,285,323,81],"y":[515,510,505,500,492,493,486,477,466,446,437,410,401,369,361,336,329,302,292,273,271,241,232,200,192,160,155,127,125,106,97,100,95,93,94,87,90,72,58,58,52,33,28,21,15,11],"c":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[138,159,81,81,81,81,81,86,102,128,149,165,174,175,174,175,174,174,150,127,101],"y":[186,50,187,159,129,100,70,47,29,21,26,41,61,80,109,138,166,186,189,188,189],"c":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    id = Uuid().v4();
    tileRepo.upsert(Tile(
        id: id,
        cardId: 'dummy',
        content:
            '{"id":"$id","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":[138,159,81,81,81,81,81,86,102,128,149,165,174,175,174,175,174,174,150,127,101],"y":[186,50,187,159,129,100,70,47,29,21,26,41,61,80,109,138,166,186,189,188,189],"c":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}}]}',
        type: TileType.dot,
        userId: user.id));

    print('Added main user: $user');
    return await userDao.insert(user);
  }

  Future<int> delete(int id) async {
    return await userDao.delete(id);
  }

  Future<int> update(User user) async {
    return await userDao.update(user);
  }
}
