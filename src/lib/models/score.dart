import 'package:hive_flutter/adapters.dart';
import 'package:matchpoint/models/starting.dart';
import 'package:matchpoint/models/team.dart';

import 'game.dart';
part 'score.g.dart';

@HiveType(typeId: 3)
class Score extends HiveObject {
  @HiveField(0)
  int score;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  int turnOver;
  @HiveField(8)
  int block;
  @HiveField(9)
  Starting starting;
  @HiveField(10)
  Team team;
  @HiveField(11)
  Game game;

  Score(this.score, this.createdAt, this.turnOver, this.block, this.starting,
      this.team, this.game);
}
