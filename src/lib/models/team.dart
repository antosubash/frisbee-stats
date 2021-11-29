import 'package:hive/hive.dart';
part 'team.g.dart';

@HiveType(typeId: 1)
class Team extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime createdAt;
  Team(this.name, this.description, this.createdAt);
}
