import 'dart:convert';

import 'package:maui/db/entity/example.dart';
import 'package:test/test.dart';

void main() {
  test('JsonSerializable', () {
    final person = Person('Inigo', 'Montoya', DateTime(1560, 5, 5))
      ..orders = [Order(DateTime.now())..item = (Item()..count = 42)];

    final personJson = _encode(person);
    print(personJson);
    final person2 =
        Person.fromJson(json.decode(personJson) as Map<String, dynamic>);

    expect(person.firstName, person2.firstName);
    expect(person.lastName, person2.lastName);
    expect(person.dateOfBirth, person2.dateOfBirth);
    expect(person.orders.single.date, person2.orders.single.date);
    expect(person.orders.single.item.count, 42);

    expect(_encode(person2), equals(personJson));
  });
}

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);
