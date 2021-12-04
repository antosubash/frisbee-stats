import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/components/score/add_score.dart';
import 'package:matchpoint/constants.dart';
import 'package:matchpoint/extension.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/score.dart';
import 'package:matchpoint/models/starting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

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
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 150.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: 'download',
                onPressed: () async {
                  await _createCSV();
                },
                child: const Icon(Icons.file_download),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80.0),
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
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        : 'Offence')),
                    trailing: Text('Team: ' + score.team.name),
                  );
                },
                itemCount: scores.length,
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  Column gameDisplayContent(String display, String value) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              display,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _createCSV() async {
    Directory? appDocDir = await getExternalStorageDirectory();
    String? appDocPath = appDocDir?.path;
    var fileName = widget.game.createdAt.day.toString() +
        '_' +
        widget.game.createdAt.month.toString() +
        '_' +
        widget.game.createdAt.year.toString() +
        "_" +
        widget.game.name +
        ".csv";
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      final file = File('$appDocPath/$fileName');
      final score = Hive.box<Score>(Constants.scores);
      List<List<dynamic>> rows = [];
      List<dynamic> row = [];
      row.add('Game');
      row.add("Game Time");
      row.add("Team");
      row.add("Opponent");
      row.add("Starting");
      row.add("Blocks");
      row.add("Turnovers");
      row.add("Winner");
      row.add("Created At");
      rows.add(row);
      for (var i = 0; i < score.length; i++) {
        row = [];
        row.add(widget.game.name);
        row.add(widget.game.createdAt.toString());
        row.add(widget.game.team.name);
        row.add(widget.game.opponent.name);
        row.add(score.getAt(i)!.starting.toString());
        row.add(score.getAt(i)!.block.toString());
        row.add(score.getAt(i)!.turnOver.toString());
        row.add(score.getAt(i)!.team.name);
        row.add(score.getAt(i)!.createdAt.toString());
        rows.add(row);
      }
      String csv = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csv);
      OpenFile.open(file.path, type: "text/csv");
    }
  }
}
