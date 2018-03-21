import 'package:test/test.dart';
import 'package:maui/db/dao/user_dao.dart';
import 'package:maui/db/entity/user.dart';

void main() {
  test("Query the table", () async {
    final userDao = new UserDao();
    await userDao.insert(new User(id: '1', name: 'Mad Hatter', image: 'mad_hatter.png'));
    final user = await userDao.getUser('1');
    expect(user.id, equals('1'));
  });
}