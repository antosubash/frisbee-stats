import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:matchpoint/Constants.dart';
import 'package:matchpoint/components/game/add_games.dart';
import 'package:matchpoint/components/game/view_game.dart';
import 'package:matchpoint/components/score/add_score.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/team.dart';

class GamesList extends StatefulWidget {
  const GamesList({Key? key}) : super(key: key);

  @override
  _GamesListState createState() => _GamesListState();
}

class _GamesListState extends State<GamesList> {
  late final Box gameBox;
  late final Box teamBox;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    gameBox = Hive.box<Game>(Constants.games);
    teamBox = Hive.box<Team>(Constants.teams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddGames()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Game>(Constants.games).listenable(),
        builder: (context, Box<Game> box, _) {
          final List<Game> games = box.values.toList()
            ..sort((a, b) {
              return b.createdAt.compareTo(a.createdAt);
            });
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No Games"),
            );
          }
          return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                Game? game = games[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewGame(game: game!),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    game!.name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(game.createdAt),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ]),
                            Text(game.description)
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
