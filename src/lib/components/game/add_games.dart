import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/constants.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/team.dart';

class AddGames extends StatefulWidget {
  const AddGames({Key? key}) : super(key: key);

  @override
  _AddGamesState createState() => _AddGamesState();
}

class _AddGamesState extends State<AddGames> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Team? team;
  Team? opponent;
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
        title: const Text('Start Game'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name"),
              TextFormField(
                controller: _nameController,
              ),
              const SizedBox(height: 24.0),
              const Text('Description'),
              TextFormField(
                controller: _descriptionController,
              ),
              const SizedBox(height: 24.0),
              const Text('Your Team'),
              DropdownButton<Team>(
                  isExpanded: true,
                  value: team,
                  items: teamBox.values.map((item) {
                    return DropdownMenuItem<Team>(
                      value: item,
                      child: Text(item.name),
                    );
                  }).toList(),
                  onChanged: (currentTeam) {
                    setState(() {
                      team = currentTeam;
                    });
                  }),
              const SizedBox(height: 24.0),
              const Text('Opponent Team'),
              DropdownButton<Team>(
                  isExpanded: true,
                  value: opponent,
                  items: teamBox.values.map((team) {
                    return DropdownMenuItem<Team>(
                      value: team,
                      child: Text(team.name),
                    );
                  }).toList(),
                  onChanged: (currentOpponentTeam) {
                    setState(() {
                      opponent = currentOpponentTeam;
                    });
                  }),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _addGame();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addGame() {
    if (team == null || opponent == null) {
      return;
    }
    var newGame = Game(_nameController.text, _descriptionController.text, team!,
        DateTime.now(), opponent!);
    gameBox.add(newGame);
  }
}
