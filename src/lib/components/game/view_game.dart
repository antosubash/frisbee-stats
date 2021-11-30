import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/components/score/add_score.dart';
import 'package:matchpoint/constants.dart';
import 'package:matchpoint/extension.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/score.dart';
import 'package:matchpoint/models/starting.dart';

class ViewGame extends StatefulWidget {
  final Game game;
  const ViewGame({Key? key, required this.game}) : super(key: key);

  @override
  _ViewGameState createState() => _ViewGameState();
}

class _ViewGameState extends State<ViewGame> {
  @override
  Widget build(BuildContext context) {
    var scores = Hive.box<Score>(Constants.scores)
        .values
        .where((element) => element.game.id == widget.game.id)
        .toList();

    var yourScore = scores
        .where((element) => element.team.id == widget.game.team.id)
        .toList();

    var opponentScore = scores
        .where((element) => element.team.id == widget.game.opponent.id)
        .toList();

    var yourBlocks = yourScore.sumBy((element) => element.block);

    var opponentBlocks = opponentScore.sumBy((element) => element.block);

    var yourTurnovers = yourScore.sumBy((element) => element.turnOver);
    var opponentTurnovers = opponentScore.sumBy((element) => element.turnOver);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Game'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 80.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: 'refresh',
                onPressed: () {
                  setState(() {});
                },
                child: const Icon(Icons.refresh),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: 'addScore',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddScore(game: widget.game),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            gameDisplayContent("Game: ", widget.game.name),
            gameDisplayContent("Description: ", widget.game.description),
            gameDisplayContent(
                "Created Time: ",
                widget.game.createdAt.day.toString() +
                    '/' +
                    widget.game.createdAt.month.toString() +
                    '/' +
                    widget.game.createdAt.year.toString()),
            DataTable(
              columns: <DataColumn>[
                const DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    widget.game.team.name,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    widget.game.opponent.name,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Score')),
                    DataCell(Text(yourScore.length.toString())),
                    DataCell(Text(opponentScore.length.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text("Blocks")),
                    DataCell(Text(yourBlocks.toString())),
                    DataCell(Text(opponentBlocks.toString())),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    const DataCell(Text('Turnovers')),
                    DataCell(Text(yourTurnovers.toString())),
                    DataCell(Text(opponentTurnovers.toString())),
                  ],
                ),
              ],
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                final score = scores[index];
                return ListTile(
                  title: Text('Block : ' +
                      score.block.toString() +
                      '  Turnovers: ' +
                      score.turnOver.toString()),
                  subtitle: Text((score.starting == Starting.defence
                          ? 'Defence'
                          : 'Offence') +
                      '  Team: ' +
                      score.team.name),
                  trailing: Text('Point: ' + score.score.toString()),
                );
              },
              itemCount: scores.length,
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Column gameDisplayContent(String display, String value) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                display,
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
