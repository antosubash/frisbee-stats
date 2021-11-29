import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Team extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(2)
  String description;
  Team(this.name, this.description);
}
