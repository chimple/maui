import 'dart:convert';

import 'package:maui/db/entity/activity.dart';
import 'package:maui/db/entity/chapter.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:test/test.dart';

void main() {
  test("Create the json", () async {
    Chapter chapter = Chapter(knowledges: [
      QuackCard(
          id: '1',
          type: CardType.knowledge,
          title: 'hitle',
          header: 'header',
          content: 'content',
          option: 'option'),
      QuackCard(
          id: '2',
          type: CardType.knowledge,
          title: 'hitle',
          header: 'header',
          content: 'content',
          option: 'option')
    ], activities: [
      Activity(
          card: QuackCard(
              id: '3',
              type: CardType.activity,
              title: 'hitle',
              header: 'header',
              content: 'content',
              option: 'option'),
          templates: ['1.svg', '2.svg']),
      Activity(
          card: QuackCard(
              id: '4',
              type: CardType.activity,
              title: 'hitle',
              header: 'header',
              content: 'content',
              option: 'option'),
          templates: ['3.svg', '4.svg']),
    ], quizzes: [
      Quiz(
          id: '5',
          type: QuizType.many,
          question: 'question',
          header: 'header',
          answers: ['answer1', 'answer2'],
          choices: ['choice1', 'choice2']),
      Quiz(
          id: '6',
          type: QuizType.many,
          question: 'question',
          header: 'header',
          answers: ['answer1', 'answer2'],
          choices: ['choice1', 'choice2'])
    ]);
    final json = jsonEncode(chapter);
    print(json);
    final chapterFromJson =
        Chapter.fromJson(jsonDecode(json) as Map<String, dynamic>);
    expect(chapter, equals(chapterFromJson));
  });
  test('from Excel', () async {
    final json = r'''
{"knowledges": [{"id": "18218_3", "type": "knowledge", "title": null, "header": "asb/13337.png", "content": "Adun alikuwa msichana mrembo sana. Wanaume kutoka kijijini kwake, wangependa wamuoe. Lakini, Adun aliwakataa wote.", "option": null}, {"id": "18218_4", "type": "knowledge", "title": null, "header": "asb/13338.png", "content": "Ilikuwa siku ya soko. Mamboleo aliomba miguu kutoka kwa mwanamume mmoja, mikono kutoka kwa mwingine, na kiwiliwili kutoka kwa mtu tofauti. Kisha Mamboleo akaziunganisha sehemu hizo tofauti. Akakiweka kichwa chake juu yake halafu akaenda sokoni.", "option": null}, {"id": "18218_5", "type": "knowledge", "title": null, "header": "asb/13339.png", "content": "Mamboleo alimtaka Adun na alikuwa na azma ya kumuoa. Adun alipendezwa na Mamboleo akataka kuolewa naye. Ingawa Mamboleo alitoka mji wa mbali, Adun alikuwa tayari kurudi naye kwake.", "option": null}, {"id": "18218_6", "type": "knowledge", "title": null, "header": "asb/13340.png", "content": "Adun na Mamboleo walipokuwa wakisafiri, mwenye miguu aliichukua. Kisha mwenye mikono akaichukua mikono yake. Mwishowe kabisa, mwenye kiwiliwili alikichukua.", "option": null}, {"id": "18218_7", "type": "knowledge", "title": null, "header": "asb/13341.png", "content": "Kichwa pekee kilibaki kikaendelea kutembea na Adun. Adun aliogopa lakini hakutoroka. Baadaye, waliwasili katika nyumba ya kichwa hicho.", "option": null}, {"id": "18218_8", "type": "knowledge", "title": null, "header": "asb/13342.png", "content": "Keshoye kabla ya kichwa kuondoka kwenda shambani,  kilimweleza Kobe, \"Adun akijaribu kutroroka, ipulize pembe hii unijulishe.\"", "option": null}, {"id": "18218_9", "type": "knowledge", "title": null, "header": "asb/13343.png", "content": "Kichwa kilipoondoka, Adun alifunganya virago vyake akitaka kutoroka.", "option": null}, {"id": "18218_10", "type": "knowledge", "title": null, "header": "asb/13344.png", "content": "Kobe alipoona hivyo, aliipuliza pembe akisema,  \"Kichwa, kichwa, Adun yu karibu kutoroka.\"", "option": null}, {"id": "18218_11", "type": "knowledge", "title": null, "header": "asb/13345.png", "content": "Kichwa kilimwendea Adun na kusema, \"Unadhani unaenda wapi?\" Adun alirejea nyumbani kwa kichwa,  shingo upande.", "option": null}, {"id": "18218_12", "type": "knowledge", "title": null, "header": "asb/13346.png", "content": "Hatimaye, Adun alitafuta mawaidha kutoka kwa mganga. Mganga alimshauri, \"Nenda ununue keki za maharage. Ziloe katika mafuta kisha uziweke ndani ya ile pembe anayoipuliza.\"", "option": null}, {"id": "18218_13", "type": "knowledge", "title": null, "header": "asb/13347.png", "content": "Adun alifuata maagizo ya mganga. Aliziweka keki zilizoloa mafuta ndani ya ile pembe.", "option": null}, {"id": "18218_14", "type": "knowledge", "title": null, "header": "asb/13349.png", "content": "Asubuhi ilipofika, Adun alivichukua virago vyake akaanza kutoroka tena. Kobe alipoichukua pembe kuipuliza, keki tamu zilianguka mdomoni kwake.", "option": null}, {"id": "18218_15", "type": "knowledge", "title": null, "header": "asb/13348.png", "content": "Kobe alizila na kuzila zile keki. Adun alitoroka akaenda zake.", "option": null}, {"id": "18218_16", "type": "knowledge", "title": null, "header": null, "content": "You are free to download, copy, translate or adapt this story and use the illustrations as long as you attribute in the following way:\nAdun, mrembo\nAuthor -\nTaiwo \u1eb8hin\u1eb9ni\nTranslation -\nUrsula Nafula\nIllustration -\nWiehan de Jager\nLanguage -\nKiswahili\nLevel -\nFirst paragraphs\n\u00a9 African Storybook Initiative 2015\nCreative Commons: Attribution 4.0\nSource\nwww.africanstorybook.org", "option": null}], "activities": [{"card": {"id": "18218_17", "type": "activity", "title": "Chora Pembe", "header": "18218.svg", "content": null, "option": null}, "templates": ["18218.svg"]}], "quizzes": [{"id": "18218_18", "type": "oneAtATime", "question": "Adhun alikua mrembo sana.", "header": null, "answers": ["Kweli"], "choices": ["Si kweli"]}, {"id": "18218_21", "type": "many", "question": "Mwanaume aliazima nini?", "header": null, "answers": ["Miguu", "Mikono", "Mwili"], "choices": ["Kofia", "Keki", "Kobe"]}, {"id": "18218_28", "type": "oneAtATime", "question": "Hadithi inatufundisha tusiongee na_________.", "header": null, "answers": ["Watu wasiojulikana"], "choices": ["Marafiki", "Dada", "baba"]}, {"id": "18218_33", "type": "open", "question": "Utaazima nini kutoka kwa wengine?", "header": "asb/13337.png", "answers": [], "choices": ["Begi", "nguo", "Chakula", "Kofia"]}]}
''';
    final chapterFromJson =
        Chapter.fromJson(jsonDecode(json) as Map<String, dynamic>);
    print(chapterFromJson);
    expect(chapterFromJson.knowledges.first.id, "18218_3");
  });
}
