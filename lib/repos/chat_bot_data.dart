import 'dart:math';

final Map<String, List<String>> replySwa = {
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

final List<String> oneLinersSwa = [
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

final Map<String, List<String>> replyEng = {
  'What makes you happy?': [
    'Playing',
    'Eating',
    'Sleeping',
    'Talking with friends'
  ],
  'What makes you sad?': ['Crying', 'Falling down', 'Darkness', 'Fighting'],
  'What makes you laugh?': [
    'Listening to jokes',
    'Seeing funny things',
    'Tickling',
    'Funny faces'
  ],
  'How old are you?': ['I don’t know', 'As old as you'],
  'How old is your mom?': ['I don’t know', 'As old as your mom'],
  'How old is your dad?': ['I don’t know', 'As old as your dad'],
  'Who is your best friend?': ['You', 'My sister', 'My brother', 'My friend'],
  'What are you good at?': ['Jumping', 'Running', 'Reading', 'Writing'],
  'What are you not good at?': [
    'Drawing',
    'Climbing',
    'Counting',
    'Staying quiet'
  ],
  'What did you do today?': [
    'I woke up',
    'I brushed my teeth',
    'I had my bath',
    'I wore my clothes'
  ],
  'What is your favourite food?': ['Rice', 'Chapati', 'Porridge', 'Fish'],
  'What is your favourite song?': [
    'Any happy song',
    'A fast song',
    'A song about the moon',
    'A song about my friend'
  ],
  'What is your favourite colour?': ['Red', 'Blue', 'Green', 'Yellow'],
  'What is your favourite toy?': ['Horse', 'Girl Doll', 'Boy Doll', 'Giraffe'],
  'What is your favourite fruit?': ['Banana', 'Orange', 'Mango', 'Pineapple'],
  'What is your favourite animal?': ['Zebra', 'Elephant', 'Hippo', 'Giraffe'],
  'What does dad do for work?': [
    'Farmer',
    'Carpenter',
    'Factory worker',
    'Miner'
  ],
  'What does mom do for work?': ['Farmer', 'Nurse', 'House wife', 'Cook'],
  'Where do you live?': [
    'In our house',
    'Far from here',
    'Nearby',
    'Over there'
  ],
  'Where is your favourite place to go?': [
    'The mountains',
    'The ocean',
    'The city',
    'The river'
  ],
  'What is your favourite time of the day?': [
    'Morning',
    'Afternoon',
    'Evening',
    'Night'
  ],
  'What makes a good friend?': [
    'Kindness',
    'Affection',
    'Playfulness',
    'Loyalty'
  ],
  'What is your favourite word?': ['Food', 'Sleep', 'Play', 'Talk'],
  'What is the funniest thing you can think of?': [
    'A joke',
    'My dad snoring',
    'A book',
    'My stomach growling'
  ],
  'What do you like best about your sister?': [
    'Looks after me',
    'Affectionate',
    'Caring',
    'Plays with me'
  ],
  'What do you like best about your brother?': [
    'Plays with me',
    'Teaches me',
    'Protects me',
    'Tells me stories'
  ],
  'Do you have a brother?': ['Yes', 'No'],
  'Do you have a sister?': ['Yes', 'No'],
  'If you could go anywhere, where would you go?': [
    'All over the world',
    'The city',
    'A ship',
    'A school'
  ],
  'What do you think your first job will be?': [
    'Doctor',
    'Engineer',
    'Officer',
    'Policeman'
  ],
  'What do you admire the most?': [
    'Honesty',
    'Cleanliness',
    'Respect',
    'Loyalty'
  ],
  'What do you like most about reading?': [
    'I can learn anything',
    'I can go to school',
    'I can teach my sister',
    'I will be respected'
  ],
  'What is your idea of a perfect day?': [
    'Sleeping all day',
    'Playing with my friends',
    'Going in the bus',
    'Going to the fair'
  ],
  'What do you want to be when you grow up?': [
    'Pilot',
    'Driver',
    'Teacher',
    'Shopkeeper'
  ],
  'What scares you the most?': [
    'Darkness',
    'Hunger',
    'Loud voices',
    'Fighting'
  ],
  'What is the nicest thing a friend has done to you?': [
    'Gave me food',
    'Played with me',
    'Took me home',
    'Studied with me'
  ],
  'What is the first thing you can remember?': [
    'My mother',
    'My father',
    'Our House',
    'Our Village'
  ],
  'What have you learnt today?': ['Reading', 'Writing', 'Counting', 'Stories'],
  'How are you?': ['I am good', 'All right', 'Not too good', 'Super'],
  'How do you feel?': ['Happy', 'Sad', 'Excited', 'Angry'],
  'Who made you smile today?': [
    'My friend',
    'My father',
    'My mother',
    'My grand father'
  ],
  'Who does your best friend remind you of?': [
    'My father',
    'Hippo',
    'Gorilla',
    'Myself'
  ],
  'What do you like in your village?': [
    'The houses',
    'The people',
    'The shops',
    'My friends'
  ],
  'What is your favourite game?': [
    'Football',
    'Jumping rope',
    'Catching ball',
    'Flying kite'
  ],
  'When did you wake up today?': ['Early', 'Late', 'Morning', 'Afternoon']
};

final List<String> oneLinersEng = [
  'What makes you happy?',
  'What makes you sad?',
  'What makes you laugh?',
  'How old are you?',
  'How old is your mom?',
  'How old is your dad?',
  'Who is your best friend?',
  'What are you good at?',
  'What are you not good at?',
  'What did you do today?',
  'What is your favourite food?',
  'What is your favourite song?',
  'What is your favourite colour?',
  'What is your favourite toy?',
  'What is your favourite fruit?',
  'What is your favourite animal?',
  'What does dad do for work?',
  'What does mom do for work?',
  'Where do you live?',
  'Where is your favourite place to go?',
  'What is your favourite time of the day?',
  'What makes a good friend?',
  'What is your favourite word?',
  'What is the funniest thing you can think of?',
  'What do you like best about your sister?',
  'What do you like best about your brother?',
  'Do you have a brother?',
  'Do you have a sister?',
  'If you could go anywhere, where would you go?',
  'What do you think your first job will be?',
  'What do you admire the most?',
  'What do you like most about reading?',
  'What is your idea of a perfect day?',
  'What do you want to be when you grow up?',
  'What scares you the most?',
  'What is the nicest thing a friend has done to you?',
  'What is the first thing you can remember?',
  'What have you learnt today?',
  'How are you?',
  'How do you feel?',
  'Who made you smile today?',
  'Who does your best friend remind you of?',
  'What do you like in your village?',
  'What is your favourite game?',
  'When did you wake up today?'
];

List<String> getPossibleReplies(String currentChat, int num) {
  final reply = replyEng;
  final oneLiners = oneLinersEng;
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
