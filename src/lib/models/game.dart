import 'package:hive/hive.dart';
import 'package:matchpoint/models/team.dart';
part 'game.g.dart';

@HiveType(typeId: 2)
class Game extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  Team team;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  Team opponent;
  @HiveField(5)
  String id;
  Game(this.id, this.name, this.description, this.team, this.createdAt,
      this.opponent);
}
