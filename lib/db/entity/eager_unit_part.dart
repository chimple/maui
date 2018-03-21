import 'unit.dart';
import 'unit_part.dart';

class EagerUnitPart {
  UnitPart unitPart;
  Unit unit;
  Unit partUnit;

  EagerUnitPart({this.unitPart, this.unit, this.partUnit});

  EagerUnitPart.fromMap(Map<String, dynamic> map)
      : this(
      unitPart: new UnitPart.fromMap(map),
      unit: new Unit.fromMap(map, prefix: 'u_'),
      partUnit: new Unit.fromMap(map, prefix: 'p_')
  );

  @override
  int get hashCode =>
      unitPart.hashCode ^
      unit.hashCode ^
      partUnit.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EagerUnitPart &&
              runtimeType == other.runtimeType &&
              unitPart == other.unitPart &&
              unit == other.unit &&
              partUnit == other.partUnit;

  @override
  String toString() {
    return 'EagerUnitPart{unitPart: $unitPart, unit: $unit, partUnit: $partUnit}';
  }

}