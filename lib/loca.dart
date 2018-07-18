import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'l10n/messages_all.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Loca {
  static Future<Loca> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return Loca();
    });
  }

  static Loca of(BuildContext context) {
    return Localizations.of<Loca>(context, Loca);
  }

  String intl(String name) => Intl.message(name, name: name);
  String get title => Intl.message('Maui', name: 'title');
  String get chat => Intl.message('Chat', name: 'chat');
  String get game => Intl.message('Game', name: 'game');
  String get reflex => Intl.message('reflex', name: 'reflex');
  String get order_it => Intl.message('Order It', name: 'order_it');
  String get memory => Intl.message('Memory', name: 'memory');
  String get draw_challenge =>
      Intl.message('draw_challenge', name: 'draw_challenge');
  String get abacus => Intl.message('Abacus', name: 'abacus');
  String get crossword => Intl.message('Crossword', name: 'crossword');
  String get drawing => Intl.message('drawing', name: 'drawing');
  String get fill_in_the_blanks =>
      Intl.message('Fill In The Blanks', name: 'fill_in_the_blanks');
  String get calculate_numbers =>
      Intl.message('Calculate', name: 'calculate_numbers');
  String get casino => Intl.message('Casino', name: 'casino');
  String get match_the_following =>
      Intl.message('Match', name: 'match_the_following');
  String get bingo => Intl.message('Bingo', name: 'bingo');
  String get true_or_false =>
      Intl.message('True Or False', name: 'true_or_false');
  String get tables => Intl.message('Tables', name: 'tables');
  String get identify => Intl.message('identify', name: 'identify');
  String get hint => Intl.message('Type image', name: 'hint');
  String get picture_sentence =>
      Intl.message('Picture Sentence', name: 'picture_sentence');
  String get fill_number => Intl.message('Fill Number', name: 'fill_number');
  String get quiz => Intl.message('Quiz', name: 'quiz');
  String get connect_the_dots =>
      Intl.message('Connect The Dots', name: 'connect_the_dots');
  String get tap_home => Intl.message('Tap Home', name: 'tap_home');
  String get tap_wrong => Intl.message('Tap Wrong', name: 'tap_wrong');
  String get guess => Intl.message('guess', name: 'guess');
  String get clue_game => Intl.message('Clue', name: 'clue_game');
  String get wordgrid => Intl.message('Word Grid', name: 'wordgrid');
  String get spin_wheel => Intl.message('Spin The Wheel', name: 'spin_wheel');
  String get first_word => Intl.message('First Word', name: 'first_word');
  String get friend_word => Intl.message('Friend Word', name: 'friend_word');
  String get dice => Intl.message('Dice', name: 'dice');
  String get circle_word => Intl.message('Circle Word', name: 'circle_word');
  String get family => Intl.message('Family', name: 'family');
  String get friends => Intl.message('Friends', name: 'friends');
}

class LocaDelegate extends LocalizationsDelegate<Loca> {
  const LocaDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'sw'].contains(locale.languageCode);

  @override
  Future<Loca> load(Locale locale) => Loca.load(locale);

  @override
  bool shouldReload(LocaDelegate old) => false;
}

class FallbackMaterialLocalisationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(FallbackMaterialLocalisationsDelegate old) => false;
}
