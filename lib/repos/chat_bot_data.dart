import 'dart:math';

Map<String, List<String>> reply = {
  'Mbona una furaha?': [
    'Nacheza',
    'Nakula',
    'Kwa kua nalala',
    'Naongea na marafiki zangu'
  ],
  'Mbona una huzuni?': ['Nalia', 'Nimeanguka chini', 'Kuna giza', 'Nimepigana'],
  'Mbona una cheka?': [
    'Nasikiliza Utani',
    'Naona vituko',
    'Ninavutiwa',
    'Nyuso zinachekesha'
  ],
  'Una miaka mingapi?': ['Sijui', 'Tunalingana'],
  'Mama yako ana miaka mingapi?': ['Sijui', 'Analingana na mama yako'],
  'Baba yako ana miaka mingapi?': ['Sijui', 'Analingana na baba yako'],
  'Rafiki yako nani?': ['Wewe', 'Dada yangu', 'Kaka yangu', 'Rafiki yangu'],
  'Unaweza nini?': ['Kuruka', 'Kukimbia', 'Kusoma', 'Kuandika'],
  'Nini hauwezi?': ['Kuchora', 'Kupanda juu', 'Kuhesabu', 'Kukaa kimya'],
  'Ulifanya nini leo?': [
    'Niliamka',
    'Nilipiga Mswaki',
    'Nilikoga',
    'Nilivaa nguo zangu'
  ],
  'Unapenda chakula gani?': ['Wali', 'Chapati', 'Uji', 'Samaki'],
  'Unapenda Wimbo gani?': [
    'Wimbo wowote mzuri',
    'wimbo wa harakaharaka',
    'Wimbo wa Mwezi',
    'Wimbo wa rafiki yangu'
  ],
  'Unapenda rangi gani?': ['Nyekundu', 'Bluu', 'Kijani', 'Njano'],
  'Unapenda Mdoli gani?': [
    'Farasi',
    'Mdoli wa Kike',
    'Mdoli wa kiume',
    'Twiga'
  ],
  'Unapenda Tunda gani?': ['Ndizi', 'Chungwa', 'Embe', 'Nanasi'],
  'Unapenda Mnyama gani?': ['Pundamilia', 'Tembo', 'Kiboko', 'Twiga'],
  'Baba anafanya kazi gani?': [
    'Mkulima',
    'Fundi mbao',
    'Ya Kiwandani',
    'Ya Madini'
  ],
  'Mama anafanya kazi gani?': [
    'Mkulima',
    'Muuguzi',
    'Mama wa nyumbani',
    'anapika'
  ],
  'unaishi wapi?': [
    'Nyumbani kwetu',
    'Mbali na hapa',
    'karibu na hapa',
    'Pale'
  ],
  'Unapenda kwenda wapi?': ['Milimani', 'Bichi', 'Mjini', 'Mtoni'],
  'Unapenda muda gani?': ['Asubuhi', 'Mchana', 'Jioni', 'Usiku'],
  'Unamjuaje rafiki mzuri?': ['Mpole', 'Ana upendo', 'Michezo', 'Muaminifu'],
  'Unapenda neno gani?': ['Chakula', 'Kulala', 'Kucheza', 'Kuongea'],
  'Unaweza kufanya kitu gani cha kuchekesha': [
    'Utani',
    'Baba yangu anakoroma',
    'Kitabu',
    'Tumbo langu linanguruma'
  ],
  'Unampendea nini dada yako?': [
    'Ananijali',
    'Ananipenda',
    'Ananitunza',
    'Anacheza na mimi'
  ],
  'Unampendea nini kaka yako?': [
    'Anacheza na mimi',
    'ananifundisha',
    'Ananilinda',
    'Ananisimuliaga Hadithi'
  ],
  'We una kaka?': ['Ndiyo', 'Hapana'],
  'We una dada?': ['Ndiyo', 'Hapana'],
  'Ukiambiwa uchague sehemu ya kwenda, utaenda wapi?': [
    'Duniani kote',
    'Mjini',
    'Kwenye meli',
    'Shule'
  ],
  'Ukiwa mkubwa unataka kuwa nani?': ['Daktari', 'Injinia', 'Afisa', 'Polisi'],
  'Unapenda nini?': ['Uamimifu', 'Usafi', 'Heshima', 'Uaminifu'],
  'Unapenda kusoma nini?': [
    'Kusoma chochote',
    'Kwenda shule',
    'Kumfundisha dada yangu',
    'Kuheshimiwa'
  ],
  'unafikiria nini kuhusu hiyo siku?': [
    'Kulala siku nzima',
    'Kucheza na marafiki zangu',
    'Kwenda kwenye Basi',
    'Kwenda kwenye haki'
  ],
  'Unataka kuwa nani ukiwa mkubwa': [
    'Rubani',
    'Dereva',
    'Mwalimu',
    'Muuza duka'
  ],
  'Unaogopaga nini': ['Giza', 'Njaa', 'Sauti kubwa', 'Kupigana'],
  'Rafiki yako amekufanyia nini kizuri?': [
    'Kanipa Chakula',
    'Amecheza na mimi',
    'Amenipeleka nyumbani',
    'Kajifunza na mimi'
  ],
  'Unakumbuka nini cha kwanza?': [
    'Mama yangu',
    'Baba yangu',
    'Nyumba yetu',
    'Kijiji chetu'
  ],
  'Leo umejifunza nini?': ['Kusoma', 'Kuandika', 'Kuhesabu', 'Hadithi'],
  'Mambo!': ['Poa', 'Poa', 'Sijisikii Vizuri', 'Poa'],
  'Unajisikiaje?': ['Vizuri', 'Najisikia vibaya', 'Nasisimuka', 'Nina hasira'],
  'Nini kimekufanya utabasamu leo?': [
    'Rafiki yangu',
    'Baba yangu',
    'Mama yangu',
    'Babu yangu'
  ],
  'Unakumbuka nini ukimuona rafiki yako?': [
    'Baba yangu',
    'Kiboko',
    'Sokwe',
    'Mimi mwenyewe'
  ],
  'Unapapendea nini kijjini kwenu?': [
    'Nyumba za kijijini',
    'Watu wa kijijini',
    'Maduka',
    'Rafiki zangu'
  ],
  'Unapenda mchezo gani?': [
    'Soka',
    'Kuruka kamba',
    'Kudaka Mpira',
    'Kurusha Tiara'
  ],
  'Umeamka saa ngap leo?': ['Mapema', 'Muda si mrefu', 'Asubuhi', 'Mchana'],
};

List<String> oneLiners = [
  'Mbona una furaha?',
  'Mbona una huzuni?',
  'Mbona una cheka?',
  'Una miaka mingapi?',
  'Mama yako ana miaka mingapi?',
  'Baba yako ana miaka mingapi?',
  'Rafiki yako nani?',
  'Unaweza nini?',
  'Nini hauwezi?',
  'Ulifanya nini leo?',
  'Unapenda chakula gani?',
  'Unapenda Wimbo gani?',
  'Unapenda rangi gani?',
  'Unapenda Mdoli gani?',
  'Unapenda Tunda gani?',
  'Unapenda Mnyama gani?',
  'Baba anafanya kazi gani?',
  'Mama anafanya kazi gani?',
  'unaishi wapi?',
  'Unapenda kwenda wapi?',
  'Unapenda muda gani?',
  'Unamjuaje rafiki mzuri?',
  'Unapenda neno gani?',
  'Unaweza kufanya kitu gani cha kuchekesha',
  'Unampendea nini dada yako?',
  'Unampendea nini kaka yako?',
  'We una kaka?',
  'We una dada?',
  'Ukiambiwa uchague sehemu ya kwenda, utaenda wapi?',
  'Ukiwa mkubwa unataka kuwa nani?',
  'Unapenda nini?',
  'Unapenda kusoma nini?',
  'unafikiria nini kuhusu hiyo siku?',
  'Unataka kuwa nani ukiwa mkubwa',
  'Unaogopaga nini',
  'Rafiki yako amekufanyia nini kizuri?',
  'Unakumbuka nini cha kwanza?',
  'Leo umejifunza nini?',
  'Mambo!',
  'Unajisikiaje?',
  'Nini kimekufanya utabasamu leo?',
  'Unakumbuka nini ukimuona rafiki yako?',
  'Unapapendea nini kijjini kwenu?',
  'Unapenda mchezo gani?',
  'umeamka saa ngap leo?'
];

List<String> getPossibleReplies(String currentChat, int num) {
  print('getPossibleReplies: $currentChat ${reply[currentChat]}');
  List<String> possibleReplies = reply[currentChat] ?? List<String>()
    ..shuffle();
  if (possibleReplies.length < num) {
    var rand = new Random();
    Set<String> set = Set<String>();
    while (set.length < num - possibleReplies.length) {
      set.add(oneLiners[rand.nextInt(oneLiners.length)]);
    }
    set.forEach((r) => possibleReplies.add(r));
  } else if (possibleReplies.length > num) {
    while (possibleReplies.length > num) {
      possibleReplies.removeLast();
    }
  }
  return possibleReplies;
}
