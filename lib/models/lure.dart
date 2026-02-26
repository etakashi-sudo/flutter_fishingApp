import 'package:isar/isar.dart';

part 'lure.g.dart';

@Collection()
class Lure {
  Id id = Isar.autoIncrement;

  late String name;
  late String brand;

  DateTime? lastUsedAt;
}
