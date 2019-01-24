import 'dart:async';
import 'dart:core';
import 'dart:math';

Future<String> getParentsAccessData(
    String word1, String word2, String word3) async {
  var random = new Random();
  var randomCase = random.nextInt(max(0, 3));
  if (!word1.contains(" ") && !word2.contains(" ")) {
    randomCase = 1;
  }

  switch (randomCase) {
    case 0:
      return "'$word1' plus '$word2'";
      break;
    case 1:
      return "'$word1' into '$word2'";
      break;
    case 2:
      return "'$word1' plus '$word2' plus '$word3'";
      break;
  }
  return null;
}

// function to convert number into words upto 3 digits
Future<String> convertToWords(String digit) async {
  int len = digit.length;
  int x = 0;
  String word = '';

  List<String> singleDigit = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  ];
  List<String> twoDigits = [
    "",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ];
  List<String> tensMultiple = [
    "",
    "",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety"
  ];
  List<String> tensPower = ["hundred", "thousand"];

  if (len == 1) {
    return singleDigit[int.parse(digit[0])];
  }

  if (len == 0) {
    return null;
  }
  if (len > 4) {
    return null;
  }
  while (x <= digit.length) {
    if (len >= 3) {
      if (int.parse(digit[x]) != 0) {
        word =
            singleDigit[int.parse(digit[x])] + " " + tensPower[len - 3] + " ";
      }
      --len;
    } else {
      if (int.parse(digit[x]) == 1) {
        int sum = int.parse(digit[x]) + int.parse(digit[x + 1]);
        return twoDigits[sum];
      } else if (int.parse(digit[x]) == 2 && int.parse(digit[x + 1]) == 0) {
        return "twenty";
      } else {
        int i = int.parse(digit[x]);
        if (i > 0) {
          word = tensMultiple[i] + " ";
        } else
          print("");
        ++x;
        if (int.parse(digit[x]) != 0) {
          word = word + singleDigit[int.parse(digit[x])];
        }
        return word;
      }
    }
    ++x;
  }
  return null;
}
