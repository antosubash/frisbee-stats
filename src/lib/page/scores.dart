import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/models/score.dart';

import '../constants.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Score"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Score>(Constants.scores).listenable(),
        builder: (context, Box<Score> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No Scores"),
            );
          }
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Score? score = box.getAt(index);
                return InkWell(
                  onTap: () {},
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(score!.score.toString()),
                            Text(score.team.name),
                            Text(score.createdAt.toString()),
                            Text(score.game.name),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
