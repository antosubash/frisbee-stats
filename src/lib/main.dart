import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/Constants.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/score.dart';
import 'package:matchpoint/models/starting.dart';
import 'package:matchpoint/models/team.dart';
import 'package:matchpoint/page/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(ScoreAdapter());
  Hive.registerAdapter(StartingAdapter());
  await Hive.openBox<Game>(Constants.games);
  await Hive.openBox<Score>(Constants.scores);
  await Hive.openBox<Team>(Constants.teams);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frisbee Matchpoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => Stack(
        children: [child!, const DropdownAlert()],
      ),
      home: const HomePage(),
    );
  }
}
