import 'unit.dart';

class UnitPart {
  static const table = 'unitPart';
  static const unitIdCol = 'unitId';
  static const partUnitIdCol = 'partUnitId';
  static const typeCol = 'type';
  static const seqCol = 'seq';
  static const ddl = '''
CREATE TABLE $table (
  $unitIdCol TEXT, 
  $partUnitIdCol TEXT, 
  $typeCol INTEGER, 
  $seqCol INTEGER, 
  PRIMARY KEY ($unitIdCol, $typeCol, $seqCol), 
  FOREIGN KEY ($unitIdCol) REFERENCES ${Unit.table}(${Unit.idCol})
  FOREIGN KEY ($partUnitIdCol) REFERENCES ${Unit.table}(${Unit.idCol}))
''';

  String unitId;
  String partUnitId;
  UnitType type;
  int seq;

  UnitPart({this.unitId, this.partUnitId, this.type, this.seq});

  Map<String, dynamic> toMap() {
    return {
      unitIdCol: unitId,
      partUnitIdCol: partUnitId,
      typeCol: type.index,
      seqCol: seq
    };
  }

  UnitPart.fromMap(Map<String, dynamic> map)
      : this(
            unitId: map[unitIdCol],
            partUnitId: map[partUnitIdCol],
            type: UnitType.values[map[typeCol]],
            seq: map[seqCol]);

  @override
  int get hashCode =>
      unitId.hashCode ^ partUnitId.hashCode ^ type.hashCode ^ seq.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitPart &&
          runtimeType == other.runtimeType &&
          unitId == other.unitId &&
          partUnitId == other.partUnitId &&
          type == other.type &&
          seq == other.seq;

  @override
  String toString() {
    return 'UnitPart{unitId: $unitId, partUnitId: $partUnitId, type: $type, seq: $seq}';
  }
}
