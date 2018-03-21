enum UnitType { letter, phonetic, syllable, word, sentence }

class Unit {
  static const table = 'unit';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const typeCol = 'type';
  static const imageCol = 'image';
  static const soundCol = 'sound';
  static const phonemeSoundCol = 'phonemeSound';
  static const ddl = '''
CREATE TABLE $table (
  $idCol INTEGER PRIMARY KEY, 
  $nameCol TEXT, 
  $typeCol INTEGER, 
  $imageCol TEXT, 
  $soundCol TEXT, 
  $phonemeSoundCol TEXT)
''';

  int id;
  String name;
  UnitType type;
  String image;
  String sound;
  String phonemeSound;

  Unit(
      {this.id,
      this.name,
      this.type,
      this.image,
      this.sound,
      this.phonemeSound});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      nameCol: name,
      typeCol: type.index,
      imageCol: image,
      soundCol: sound,
      phonemeSoundCol: phonemeSound
    };
  }

  Unit.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idCol],
            name: map[nameCol],
            type: UnitType.values[map[typeCol]],
            image: map[imageCol],
            sound: map[soundCol],
            phonemeSound: map[phonemeSoundCol]);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      image.hashCode ^
      sound.hashCode ^
      phonemeSound.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          image == other.image &&
          sound == other.sound &&
          phonemeSound == other.phonemeSound;

  @override
  String toString() {
    return 'Unit{id: $id, name: $name, type: $type, image: $image, sound: $sound, phonemeSound: $phonemeSound}';
  }
}
