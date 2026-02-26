import 'package:isar/isar.dart';

part 'lure.g.dart';

enum LureCategory {
  minnow('ミノー'),
  crankbait('クランクベイト'),
  vibration('バイブレーション'),
  metalJig('メタルジグ'),
  other('その他');

  const LureCategory(this.displayName);
  final String displayName;
}

@Collection()
class Lure {
  Id id = Isar.autoIncrement;

  // 製品名
  late String name;
  // メーカー
  late String brand;

  @enumerated
  LureCategory category = LureCategory.other; // ジャンル

  DateTime? lastUsedAt;
}
