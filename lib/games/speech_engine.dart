import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() async {
  runApp(new SpeechRecognitionApp(lang: 'en', country: 'US'));
}

const supportedLanguages = const [
  const Language('en', 'US'),
  const Language('hi', 'IN')
];

class Language {
  final String lang;
  final String country;

  const Language(this.lang, this.country);
}

class SpeechRecognitionApp extends StatefulWidget {
  final String lang;
  final String country;

  SpeechRecognitionApp({@required this.lang, @required this.country});

  @override
  _SpeechRecognitionState createState() => new _SpeechRecognitionState();
}

class _SpeechRecognitionState extends State<SpeechRecognitionApp> {
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String speechText = '';
  Language selectedLang = supportedLanguages.first;

  @override
  initState() {
    super.initState();
    initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void initialize() {
    SimplePermissions.requestPermission(Permission.RecordAudio);

    print('_SpeechRecognitionState.initialize... ');
    _speech = new SpeechRecognition();
    _speech.setSpeechRecognitionAvailableHandler(onSpeechRecognitionAvailable);
    _speech.setSpeechCurrentLocaleHandler(onSpeechCurrentLocaleSelected);
    _speech.setSpeechRecognitionResultHandler(onSpeechRecognitionResult);
    _speech.setSpeechRecognitionOnErrorHandler(onSpeechRecognitionError);

    _speech
        .initialize()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('SpeechRecognition'),
          actions: [
            new PopupMenuButton<Language>(
              onSelected: _selectLangHandler,
              itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
            )
          ],
        ),
        body: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Center(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new Expanded(
                      child: new Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey.shade200,
                          child: new Text(speechText))),
                  _buildButton(
                    onPressed: _speechRecognitionAvailable && !_isListening
                        ? () => startListening()
                        : null,
                    label: _isListening
                        ? 'Listening...'
                        : 'Listen (${selectedLang.lang} - ${selectedLang.country})',
                  ),
                  _buildButton(
                    onPressed: _isListening ? () => stopListening() : null,
                    label: 'Stop',
                  ),
                ],
              ),
            )),
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets =>
      supportedLanguages
          .map((l) => new CheckedPopupMenuItem<Language>(
                value: l,
                checked: selectedLang == l,
                child: new Text(l.lang + '_' + l.country),
              ))
          .toList();

  void _selectLangHandler(Language selectedNewLang) async {
    print(
        "select lang handler changed: ${selectedNewLang.country} and ${selectedNewLang.lang}");
    speechText = "";
    setState(() => selectedLang = selectedNewLang);
    await _speech.changeLocale(selectedNewLang.lang, selectedNewLang.country);
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
        padding: new EdgeInsets.all(12.0),
        child: new RaisedButton(
          color: Colors.cyan.shade600,
          onPressed: onPressed,
          child: new Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  void startListening() =>
      _speech.listen(selectedLang.lang, selectedLang.country).then((result) {
        print('_SpeechRecognitionAppState.start => result ${result}');
        speechText = "";
        setState(() => _isListening = true);
      });

  void stopListening() =>
      _speech.stop().then((result) => setState(() => _isListening = !result));

  void onSpeechRecognitionAvailable(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onSpeechCurrentLocaleSelected(Map<String, String> currentLocale) {
    String lang = currentLocale['lang'];
    String country = currentLocale['country'];
    print(
        '_SpeechRecognitionAppState.onSpeechCurrentLocaleSelected lang $lang and country $country');
    setState(() => selectedLang = supportedLanguages
        .firstWhere((l) => l.country == country && l.lang == lang));
  }

  void onSpeechRecognitionResult(String text) {
    print('_SpeechRecognitionAppState.onSpeechRecognitionResult -> $text}');
    setState(() => speechText = speechText + " " + text);
  }

  void onSpeechRecognitionError(bool result) {
    print('_SpeechRecognitionAppState.onSpeechRecognitionError -> $result}');
    setState(() => _isListening = false);
  }
}
