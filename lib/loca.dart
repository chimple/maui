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
  String get gallery => Intl.message('Gallery', name: 'gallery');
  String get collection => Intl.message('Collection', name: 'collection');
  String get progress => Intl.message('Progress', name: 'progress');
  String get game => Intl.message('Game', name: 'game');
  String get home => Intl.message("Home", name: 'home');
  String get category => Intl.message('Category', name: 'category');
  String get profile => Intl.message('Profile', name: 'profile');
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
  String get no_data => Intl.message('No Data', name: 'no_data');
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
  String get quiz_pager => Intl.message('Quiz', name: 'quiz_pager');
  String get family => Intl.message('Family', name: 'family');
  String get friends => Intl.message('Friends', name: 'friends');
  String get owl => Intl.message('owl', name: 'owl');
  String get giraffe => Intl.message('giraffe', name: 'giraffe');
  String get rabbit => Intl.message('rabbit', name: 'rabbit');
  String get dog => Intl.message('dog', name: 'dog');
  String get cat => Intl.message('cat', name: 'cat');
  String get monkey => Intl.message('monkey', name: 'monkey');
  String get bear => Intl.message('bear', name: 'bear');
  String get frog => Intl.message('frog', name: 'frog');
  String get red => Intl.message('red', name: 'red');
  String get yellow => Intl.message('yellow', name: 'yellow');
  String get orange => Intl.message('orange', name: 'orange');
  String get blue => Intl.message('blue', name: 'blue');
  String get green => Intl.message('green', name: 'green');
  String get pink => Intl.message('pink', name: 'pink');
  String get cyan => Intl.message('cyan', name: 'cyan');
  String get purple => Intl.message('purple', name: 'purple');
  String get brown => Intl.message('brown', name: 'brown');
  String get maroon => Intl.message('maroon', name: 'maroon');
  String get tulip => Intl.message('tulip', name: 'tulip');
  String get hibiscus => Intl.message('hibiscus', name: 'hibiscus');
  String get lotus => Intl.message('lotus', name: 'lotus');
  String get orchid => Intl.message('orchid', name: 'orchid');
  String get daffodil => Intl.message('daffodil', name: 'daffodil');
  String get jasmine => Intl.message('jasmine', name: 'jasmine');
  String get lavender => Intl.message('lavender', name: 'lavender');
  String get sunflower => Intl.message('sunflower', name: 'sunflower');
  String get rose => Intl.message('rose', name: 'rose');
  String get chamomile => Intl.message('chamomile', name: 'chamomile');
  String get candle => Intl.message('candle', name: 'candle');
  String get toaster => Intl.message('toaster', name: 'toaster');
  String get teddy_bear => Intl.message('teddy bear', name: 'teddy_bear');
  String get bulb => Intl.message('bulb', name: 'bulb');
  String get sofa => Intl.message('sofa', name: 'sofa');
  String get headphones => Intl.message('headphones', name: 'headphones');
  String get microwave_oven =>
      Intl.message('microwave oven', name: 'microwave_oven');
  String get carpet => Intl.message('carpet', name: 'carpet');
  String get watch => Intl.message('watch', name: 'watch');
  String get clock => Intl.message('clock', name: 'clock');
  String get eagle => Intl.message('eagle', name: 'eagle');
  String get kingfisher => Intl.message('kingfisher', name: 'kingfisher');
  String get parrot => Intl.message('parrot', name: 'parrot');
  String get bat => Intl.message('bat', name: 'bat');
  // String get owl => Intl.message('owl', name: 'owl');
  String get peacock => Intl.message('peacock', name: 'peacock');
  String get swan => Intl.message('swan', name: 'swan');
  String get rooster => Intl.message('rooster', name: 'rooster');
  String get duck => Intl.message('duck', name: 'duck');
  String get dove => Intl.message('dove', name: 'dove');
  String get face => Intl.message('face', name: 'face');
  String get upper_body => Intl.message('upper body', name: 'upper_body');
  String get right_hand => Intl.message('right hand', name: 'right_hand');
  String get left_hand => Intl.message('left hand', name: 'left_hand');
  String get right_palm => Intl.message('right palm', name: 'right_palm');
  String get left_palm => Intl.message('left palm', name: 'left_palm');
  String get right_leg => Intl.message('right leg', name: 'right_leg');
  String get left_leg => Intl.message('left leg', name: 'left_leg');
  String get right_foot => Intl.message('right foot', name: 'right_foot');
  String get left_foot => Intl.message('left foot', name: 'left_foot');
  String get cloud => Intl.message('cloud', name: 'cloud');
  String get sun => Intl.message('sun', name: 'sun');
  String get tree => Intl.message('tree', name: 'tree');
  // String get owl => Intl.message('owl', name: 'owl');
  // String get dove => Intl.message('dove', name: 'dove');
  String get leaf => Intl.message('leaf', name: 'leaf');
  String get ant => Intl.message('ant', name: 'ant');
  String get grass => Intl.message('grass', name: 'grass');
  String get stones => Intl.message('stones', name: 'stones');
  String get pot => Intl.message('pot', name: 'pot');
  String get hexagon => Intl.message('hexagon', name: 'hexagon');
  String get square => Intl.message('square', name: 'square');
  String get star => Intl.message('star', name: 'star');
  String get triangle => Intl.message('triangle', name: 'triangle');
  String get diamond => Intl.message('diamond', name: 'diamond');
  String get rectangle => Intl.message('rectangle', name: 'rectangle');
  String get rhombus => Intl.message('rhombus', name: 'rhombus');
  String get oval => Intl.message('oval', name: 'oval');
  String get pentagon => Intl.message('pentagon', name: 'pentagon');
  String get trapezoid => Intl.message('trapezoid', name: 'trapezoid');
  String get bow => Intl.message('bow', name: 'bow');
  String get suit => Intl.message('suit', name: 'suit');
  String get jacket => Intl.message('jacket', name: 'jacket');
  String get dress => Intl.message('dress', name: 'dress');
  String get heels => Intl.message('heels', name: 'heels');
  String get shoes => Intl.message('shoes', name: 'shoes');
  String get backpack => Intl.message('backpack', name: 'backpack');
  String get glasses => Intl.message('glasses', name: 'glasses');
  String get hat => Intl.message('hat', name: 'hat');
  String get coat => Intl.message('coat', name: 'coat');
  String get strawberry => Intl.message('strawberry', name: 'strawberry');
  String get apple => Intl.message('apple', name: 'apple');
  String get cherry => Intl.message('cherry', name: 'cherry');
  String get grapes => Intl.message('grapes', name: 'grapes');
  // String get orange => Intl.message('orange', name: 'orange');
  String get citrus => Intl.message('citrus', name: 'citrus');
  String get pear => Intl.message('pear', name: 'pear');
  String get watermelon => Intl.message('watermelon', name: 'watermelon');
  String get mango => Intl.message('mango', name: 'mango');
  String get banana => Intl.message('banana', name: 'banana');
  String get sister => Intl.message('Sister', name: 'sister');
  String get brother => Intl.message('Brother', name: 'brother');
  String get mother => Intl.message('Mother', name: 'mother');
  String get father => Intl.message('Father', name: 'father');
  String get friend => Intl.message('Friend', name: 'friend');
  String get hi => Intl.message('Hi', name: 'hi');
  String get hello => Intl.message('Hello', name: 'hello');
  String get letUsLearn => Intl.message('Let us learn', name: 'letUsLearn');
  String get letUsChat => Intl.message('Let us chat', name: 'letUsChat');
  String get ok => Intl.message('OK', name: 'ok');
  String get sendAMessage =>
      Intl.message('Send a message', name: 'sendAMessage');
  String get exitq => Intl.message('Exit?', name: 'exitq');
  String get youWon => Intl.message('You Won', name: 'youWon');
  String get tie => Intl.message('Tie', name: 'tie');
  String get youLoose => Intl.message('You Loose', name: 'youLoose');
  String get gameOver => Intl.message('Game Over', name: 'gameOver');
  String get waitingForTurn =>
      Intl.message('Waiting for Turn', name: 'waitingForTurn');
  String get vs => Intl.message('V/S ', name: 'vs');
  String get tapACamera => Intl.message('Tap a camera', name: 'tapACamera');
  String get enterYourDetails =>
      Intl.message('Enter your details', name: 'enterYourDetails');
  String get writeYourName =>
      Intl.message('Write your name...', name: 'writeYourName');
  String get addAComment => Intl.message('Add a comment', name: 'addAComment');

  String get draw => Intl.message('Draw', name: 'draw');
  String get post => Intl.message('Post', name: 'post');
  String get pleaseWait => Intl.message('Please wait...', name: 'pleaseWait');
  String get signIn => Intl.message('Sign In', name: 'signIn');
  String get loading => Intl.message('Loading...', name: 'loading');
  String get seeAll => Intl.message('See All', name: 'seeAll');
  String get chooseATemplate =>
      Intl.message('Choose a template', name: 'chooseATemplate');
  String get yourPoints => Intl.message('Your Points -', name: 'yourPoints');
  String get costIs => Intl.message('Cost is - 5', name: 'costIs');
  String get buy => Intl.message('Buy', name: 'buy');
  String get next => Intl.message('Next', name: 'next');
  String get check => Intl.message('Check', name: 'check');
  String get topics => Intl.message('Topics', name: 'topics');
  String get writeSomething =>
      Intl.message('Write Something', name: 'writeSomething');
  String get stories => Intl.message('Stories', name: 'stories');
  String get answerThis => Intl.message('Answer this', name: 'answerThis');
  String get hoodie => Intl.message('Hoodie', name: 'hoodie');
  String get send => Intl.message('Send', name: 'send');
  String get options => Intl.message('Options', name: 'options');
  String get edit => Intl.message('Edit', name: 'edit');
  String get delete => Intl.message('Delete', name: 'delete');
  String get games => Intl.message('Games', name: 'games');
  String get comment => Intl.message('Comment', name: 'comment');
  String get story => Intl.message('Story', name: 'story');
  String get discuss => Intl.message('Discuss', name: 'story');
  String get topic => Intl.message('Topic', name: 'topic');
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
