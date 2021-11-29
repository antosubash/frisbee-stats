import 'package:hive/hive.dart';
part 'starting.g.dart';

@HiveType(typeId: 4)
enum Starting {
  @HiveField(0)
  defence,
  @HiveField(1)
  offense,
}
