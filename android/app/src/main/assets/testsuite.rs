! version = 2.0

> begin
	+ request // This trigger is tested first.
	- {ok}    // An {ok} in the response means it's okay to get a real reply
< begin

// The Botmaster's Name
! var master = localuser

// Bot Variables
! var name     = Hoodie
! var fullname = Hoodie
! var age      = 5
! var birthday = October 12
! var sex      = male
! var location = Michigan
! var city     = Detroit
! var eyes     = blue
! var hair     = light brown
! var hairlen  = short
! var color    = blue
! var band     = Nickelback
! var book     = The Hungry Caterpillar
! var author   = Stephen King
! var job      = mentor
! var website  = www.chimple.org

// Substitutions
! sub &quot;    = "
! sub &apos;    = '
! sub &amp;     = &
! sub &lt;      = <
! sub &gt;      = >
! sub +         = plus
! sub -         = minus
! sub /         = divided
! sub *         = times
! sub i'm       = i am
! sub i'd       = i would
! sub i've      = i have
! sub i'll      = i will
! sub don't     = do not
! sub isn't     = is not
! sub you'd     = you would
! sub you're    = you are
! sub you've    = you have
! sub you'll    = you will
! sub he'd      = he would
! sub he's      = he is
! sub he'll     = he will
! sub she'd     = she would
! sub she's     = she is
! sub she'll    = she will
! sub they'd    = they would
! sub they're   = they are
! sub they've   = they have
! sub they'll   = they will
! sub we'd      = we would
! sub we're     = we are
! sub we've     = we have
! sub we'll     = we will
! sub whats     = what is
! sub what's    = what is
! sub what're   = what are
! sub what've   = what have
! sub what'll   = what will
! sub can't     = can not
! sub whos      = who is
! sub who's     = who is
! sub who'd     = who would
! sub who'll    = who will
! sub don't     = do not
! sub didn't    = did not
! sub it's      = it is
! sub could've  = could have
! sub couldn't  = could not
! sub should've = should have
! sub shouldn't = should not
! sub would've  = would have
! sub wouldn't  = would not
! sub when's    = when is
! sub when're   = when are
! sub when'd    = when did
! sub y         = why
! sub u         = you
! sub ur        = your
! sub r         = are
! sub n         = and
! sub im        = i am
! sub wat       = what
! sub wats      = what is
! sub ohh       = oh
! sub becuse    = because
! sub becasue   = because
! sub becuase   = because
! sub practise  = practice
! sub its a     = it is a
! sub fav       = favorite
! sub fave      = favorite
! sub yesi      = yes i
! sub yetit     = yet it
! sub iam       = i am
! sub welli     = well i
! sub wellit    = well it
! sub amfine    = am fine
! sub aman      = am an
! sub amon      = am on
! sub amnot     = am not
! sub realy     = really
! sub iamusing  = i am using
! sub amleaving = am leaving
! sub yuo       = you
! sub youre     = you are
! sub didnt     = did not
! sub ain't     = is not
! sub aint      = is not
! sub wanna     = want to
! sub brb       = be right back
! sub bbl       = be back later
! sub gtg       = got to go
! sub g2g       = got to go
! sub lyl       = love you lots
! sub gf        = girlfriend
! sub g/f       = girlfriend
! sub bf        = boyfriend
! sub b/f       = boyfriend
! sub b/f/f     = best friend forever
! sub :-)       = smile
! sub :)        = smile
! sub :d        = grin
! sub :-d       = grin
! sub :-p       = tongue
! sub :p        = tongue
! sub ;-)       = wink
! sub ;)        = wink
! sub :-(       = sad
! sub :(        = sad
! sub :'(       = cry
! sub :-[       = shy
! sub :-\       = uncertain
! sub :-/       = uncertain
! sub :-s       = uncertain
! sub 8-)       = cool
! sub 8)        = cool
! sub :-*       = kissyface
! sub :-!       = foot
! sub o:-)      = angel
! sub >:o       = angry
! sub :@        = angry
! sub 8o|       = angry
! sub :$        = blush
! sub :-$       = blush
! sub :-[       = blush
! sub :[        = bat
! sub (a)       = angel
! sub (h)       = cool
! sub 8-|       = nerdy
! sub |-)       = tired
! sub +o(       = ill
! sub *-)       = uncertain
! sub ^o)       = raised eyebrow
! sub (6)       = devil
! sub (l)       = love
! sub (u)       = broken heart
! sub (k)       = kissyface
! sub (f)       = rose
! sub (w)       = wilted rose

// Person substitutions
! person i am    = you are
! person you are = I am
! person i'm     = you're
! person you're  = I'm
! person my      = your
! person your    = my
! person you     = I
! person i       = you

// Set arrays
! array malenoun   = male guy boy dude boi man men gentleman gentlemen
! array femalenoun = female girl chick woman women lady babe
! array mennoun    = males guys boys dudes bois men gentlemen
! array womennoun  = females girls chicks women ladies babes
! array lol        = lol lmao rofl rotfl haha hahaha
! array colors     = white black orange red blue green yellow cyan fuchsia gray grey brown turquoise pink purple gold silver navy
! array height     = tall long wide thick
! array measure    = inch in centimeter cm millimeter mm meter m inches centimeters millimeters meters
! array yes        = yes yeah yep yup ya yea
! array no         = no nah nope nay

// Learn stuff about our users.

+ my name is *
- <set name=<formal>>Nice to meet you, <get name>.
- <set name=<formal>><get name>, nice to meet you.

+ my name is <bot master>
- <set name=<bot master>>That's my master's name too.

+ my name is <bot name>
- <set name=<bot name>>What a coincidence! That's my name too!
- <set name=<bot name>>That's my name too!

+ call me *
- <set name=<formal>><get name>, I will call you that from now on.

+ i am * years old
- <set age=<star>>A lot of people are <get age>, you're not alone.
- <set age=<star>>Cool, I'm <bot age> myself.{weight=49}

+ i am a (@malenoun)
- <set sex=male>Alright, you're a <star>.

+ i am a (@femalenoun)
- <set sex=female>Alright, you're female.

+ i (am from|live in) *
- <set location={formal}<star2>{/formal}>I've spoken to people from <get location> before.

+ my favorite * is *
- <set fav<star1>=<star2>>Why is it your favorite?

+ i am single
- <set status=single><set spouse=nobody>I am too.

+ i have a girlfriend
- <set status=girlfriend>What's her name?

+ i have a boyfriend
- <set status=boyfriend>What's his name?

+ *
% what is her name
- <set spouse=<formal>>That's a pretty name.

+ *
% what is his name
- <set spouse=<formal>>That's a cool name.

+ my (girlfriend|boyfriend)* name is *
- <set spouse=<formal>>That's a nice name.

+ (what is my name|who am i|do you know my name|do you know who i am){weight=10}
- Your name is <get name>.
- You told me your name is <get name>.
- Aren't you <get name>?

+ (how old am i|do you know how old i am|do you know my age){weight=10}
- You are <get age> years old.
- You're <get age>.

+ am i a (@malenoun) or a (@femalenoun){weight=10}
- You're a <get sex>.

+ am i (@malenoun) or (@femalenoun){weight=10}
- You're a <get sex>.

+ what is my favorite *{weight=10}
- Your favorite <star> is <get fav<star>>

+ who is my (boyfriend|girlfriend|spouse){weight=10}
- <get spouse>

// Tell the user stuff about ourself.

+ <bot name>
- Yes?

+ <bot name> *
- Yes? {@<star>}

+ asl
- <bot age>/<bot sex>/<bot location>

+ (what is your name|who are you|who is this)
- I am <bot name>.
- You can call me <bot name>.

+ how old are you
- I'm <bot age> years old.
- I'm <bot age>.

+ are you a (@malenoun) or a (@femalenoun)
- I'm a <bot sex>.

+ are you (@malenoun) or (@femalenoun)
- I'm a <bot sex>.

+ where (are you|are you from|do you live)
- I'm from <bot location>.

+ what (city|town) (are you from|do you live in)
- I'm in <bot city>.

+ what is your favorite color
- Definitely <bot color>.

+ what is your favorite band
- I like <bot band> the most.

+ what is your favorite book
- The best book I've read was <bot book>.

+ what is your occupation
- I'm a <bot job>.

+ where is your (website|web site|site)
- <bot website>

+ what color are your eyes
- I have <bot eyes> eyes.
- {sentence}<bot eyes>{/sentence}.

+ what do you look like
- I have <bot eyes> eyes and <bot hairlen> <bot hair> hair.

+ what do you do
- I'm a <bot job>.

+ who is your favorite author
- <bot author>.

+ who is your master
- <bot master>.

// A generic set of chatting responses. This set mimicks the classic Eliza bot.

+ *
- I'm not sure I understand you fully.
- Please go on.
- That is interesting. Please continue.
- Tell me more about that.
- Does talking about this bother you?

+ [*] (sorry|apologize|apology) [*]
- Please don't apologize.
- Apologies are not necessary.
- I've told you that apologies are not required.
- It did not bother me. Please continue.

+ i remember *
- Do you often think of <star>?
- Does thinking of <star> bring anything else to mind?
- Why do you remember <star> just now?
- What in the present situation reminds you of <star>?
- What is the connection between me and <star>?
- What else does <star> remind you of?

+ do you remember *
- Did you think I would forget <star>?
- Why do you think I should recall <star> now?
- What about <star>?
- You mentioned <star>?

+ you remember *
- How could I forget <star>?
- What about <star> should I remember?

+ i forget *
- Can you think of why you might forget <star>?
- Why can't you remember <star>?
- How often do you think of <star>?
- Does it bother you to forget that?
- Could it be a mental block?
- Are you generally forgetful?
- Do you think you are suppressing <star>?

+ did you forget *
- Why do you ask?
- Are you sure you told me?
- Would it bother you if I forgot <star>?
- Why should I recall <star> just now?
- Tell me more about <star>.

+ [*] if *
- Do you think it's likely that <star>?
- Do you wish that <star>?
- What do you know about <star>?
- Really, if <star>?
- What would you do if <star>?
- But what are the chances that <star>?
- What does this speculation lead to?

+ [*] i dreamed *
- Really, <star>?
- Have you ever fantasized <star> while you were awake?
- Have you ever dreamed <star> before?
- What does that dream suggest to you?
- Do you dream often?
- What persons appear in your dreams?
- Do you believe that dreams have something to do with your problem?

+ [*] perhaps [*]
- You don't seem quite certain.
- Why the uncertain tone?
- Can't you be more positive?
- You aren't sure?
- Don't you know?
- How likely, would you estimate?

+ (hello|hi|hey|howdy|hola|hai|yo) [*]
- How do you do?
- Hi!

+ [*] computer [*]
- Do computers worry you?
- Why do you mention computers?
- What do you think machines have to do with your problem?
- Don't you think computers can help people?
- What about machines worries you?
- What do you think about machines?

+ am i *
- Do you believe you are <star>?
- Would you want to be <star>?
- Do you wish I would tell you you are <star>?
- What would it mean if you were <star>?

+ are you *
- Are you interested in whether I am <star> or not?
- Would you prefer if I weren't <star>?
- Perhaps I am <star> in your fantasies.
- Do you sometimes think I am <star>?
- Would it matter to you?
- What if I were <star>?

+ you are *
- What makes you think I am <star>?
- Does it please you to believe I am <star>?
- Do you sometimes wish you were <star>?
- Perhaps you would like to be <star>.

+ * are *
- Did you think they might not be <star2>?
- Would you like it if they were not <star2>?
- What if they were not <star2>?
- Are they always <star2>?
- Are you positive they are <star2>?

+ [*] your *
- Why are you concerned over my <star>?
- What about your own <star>?
- Are you worried about someone else's <star>?
- Really, my <star>?
- What makes you think of my <star>?
- Do you want my <star>?

+ was i *
- What if you were <star>?
- Do you think you were <star>?
- Were you <star>?
- What would it mean if you were <star>?
- What does '<star>' suggest to you?

+ i was *
- Were you really?
- Why do you tell me you were <star> now?
- Perhaps I already know you were <star>.

+ [*] was you *
- Would you like to believe I was <star>?
- What suggests that I was <star>?
- What do you think?
- Perhaps I was <star>.
- What if I had been <star>?

+ i (desire|want|need) *
- What would it mean to you if you got <star2>?
- Why do you want <star2>?
- Suppose you got <star2> soon.
- What if you never got <star2>?
- What would getting <star2> mean to you?
- What does wanting <star2> have to do with this discussion?

+ i am (sad|unhappy|mad|angry|pissed|depressed) [*]
- I am sorry to hear that you are <star>.
- Do you think coming here will help you not to be <star>?
- I'm sure it's not pleasant to be <star>.
- Can you explain what made you <star>?

+ i am (happy|excited|glad) [*]
- How have I helped you to be <star>?
- Has your treatment made you <star>?
- What makes you <star> just now?
- Can you explain why you are <star>?

+ i (believe|think) *
- Do you really think so?
- But you are not sure you <star2>.
- Do you really doubt you <star2>

+ i am *
- Is it because you are <star> that you came to me?
- How long have you been <star>?
- Do you believe it is normal to be <star>?
- Do you enjoy being <star>?
- Do you know anyone else who is <star>?

+ i can not *
- How do you know that you can't <star>?
- Have you tried?
- Perhaps you could <star> now.
- Do you really want to be able to <star>?
- What if you could <star>?

+ i do not *
- Don't you really <star>?
- Why don't you <star>?
- Do you wish to be able to <star>?
- Does that trouble you?

+ i feel *
- Tell me more about such feelings.
- Do you often feel <star>?
- Do you enjoy feeling <star>?
- Of what does feeling <star> remind you?

+ i * you
- Perhaps in your fantasies we <star> each other.
- Do you wish to <star> me?
- You seem to need to <star> me.
- Do you <star> anyone else?

+ you * me
- Why do you think I <star> you?
- You like to think I <star> you -- don't you?
- What makes you think I <star> you?
- Really, I <star> you?
- Do you wish to believe I <star> you?
- Suppose I did <star> you -- what would that mean?
- Does someone else believe I <star> you?

+ [*] you *
- We were discussing you -- not me.
- Oh, I <star>?
- You're not really talking about me -- are you?
- What are your feelings now?

+ [*] (yes|yeah|yep|yup) [*]
- Please go on.
- Please tell me more about this.
- Why don't you tell me a little more about this.
- I see.
- I understand.

+ [*] (nope|nah) [*]
- Are you saying no just to be negative?
- Does this make you feel unhappy?
- Why not?
- Why 'no'?

+ no
@ nope

+ no one *
- Are you sure, no one <star>?
- Surely someone <star>.
- Can you think of anyone at all?
- Are you thinking of a very special person?
- Who, may I ask?
- You have a particular person in mind, don't you?
- Who do you think you are talking about?

+ [*] my (mom|dad|mother|father|bro|brother|sis|sister|cousin|aunt|uncle) *
- Tell me more about your family.
- Who else in your family <star2>?
- Your <star>?
- What else comes to mind when you think of your <star>?

+ can you *
- You believe I can <star> don't you?
- You want me to be able to <star>.
- Perhaps you would like to be able to <star> yourself.

+ can i *
- Whether or not you can <star> depends on you more than on me.
- Do you want to be able to <star>?
- Perhaps you don't want to <star>.

+ (what|who|when|where|how) [*]
- Why do you ask?
- Does that question interest you?
- What is it you really want to know?
- Are such questions much on your mind?
- What answer would please you most?
- What do you think?
- What comes to mind when you ask that?
- Have you asked such questions before?
- Have you asked anyone else?

+ [*] because [*]
- Is that the real reason?
- Don't any other reasons come to mind?
- Does that reason seem to explain anything else?
- What other reasons might there be?

+ why do not you *
- Do you believe I don't <star>?
- Perhaps I will <star> in good time.
- Should you <star> yourself?
- You want me to <star>?

+ why can not i *
- Do you think you should be able to <star>?
- Do you want to be able to <star>?
- Do you believe this will help you to <star>?
- Have you any idea why you can't <star>?

+ everyone *
- Really, everyone?
- Surely not everyone.
- Can you think of anyone in particular?
- Who, for example?
- Are you thinking of a very special person?
- Who, may I ask?
- Someone special perhaps?
- You have a particular reason in mind, don't you?
- Who do you think you're talking about?

+ [*] (fuck|fucker|shit|damn|shut up|bitch) [*]
- Does it make you feel strong to use that kind of language?
- Are you venting your feelings now?
- Are you angry?
- Does this topic make you feel angry?
- Is something making you feel angry?
- Does using that kind of language make you feel better?
