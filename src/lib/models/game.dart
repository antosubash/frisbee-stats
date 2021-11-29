import 'package:hive/hive.dart';
import 'package:matchpoint/models/team.dart';

@HiveType(typeId: 2)
class Game extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  Team team;
  Game(this.name, this.description, this.team);
}
