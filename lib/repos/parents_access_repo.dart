import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:tuple/tuple.dart';

Future<Tuple2<String, List<int>>> getParentsAccessData() async {
  var random = new Random();
  var randomCase = random.nextInt(max(0, 5));

  switch (randomCase) {
    case 0:
      return new Tuple2(
          "\"four\" plus \"thirteen\"", [8, 6, 1, 9, 7, 2, 3, 4, 5,0]);
      break;
    case 1:
      return new Tuple2(
          "\"ninteen\" plus \"two\" minus \"seven\"", [14, 12, 32, 28, 17]);
      break;
    case 2:
      return new Tuple2(
          "\"thirtynine\" minus \"ninteen\" minus \"ten\"", [30, 10, 20, 19]);
      break;
    case 3:
      return new Tuple2("\"eight\" divided by \"two\"", [4, 2, 3, 5, 8]);
      break;
    case 4:
      return new Tuple2("\"nine\" multiplied by \"two\"", [18, 13, 14, 15, 11]);
      break;
  }
  return null;
}
