import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/models/game.dart';
import 'package:matchpoint/models/score.dart';
import 'package:matchpoint/models/starting.dart';
import 'package:matchpoint/models/team.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';

class AddScore extends StatefulWidget {
  final Game game;
  const AddScore({Key? key, required this.game}) : super(key: key);
  @override
  _AddScoreState createState() => _AddScoreState();
}

class _AddScoreState extends State<AddScore> {
  final _key = GlobalKey<FormState>();
  late Team? team = null;
  late Starting? starting = null;
  late double block = 0;
  late double turnover = 0;
  late final Box scoreBox;
  var key = UniqueKey();

  @override
  void initState() {
    super.initState();
    scoreBox = Hive.box<Score>(Constants.scores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Score'),
        ),
        body: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 16.0,
              ),
              const Text("Starting", style: TextStyle(fontSize: 20.0)),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: CustomRadioButton(
                  key: ValueKey(starting),
                  padding: 8,
                  margin: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  elevation: 2,
                  unSelectedColor: Theme.of(context).canvasColor,
                  buttonLables: const [
                    "Defence",
                    "Offence",
                  ],
                  buttonValues: const [Starting.defence, Starting.offense],
                  buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16)),
                  radioButtonValue: (value) {
                    setState(() {
                      starting = value as Starting;
                    });
                  },
                  defaultSelected: starting,
                  selectedColor: Theme.of(context).primaryColor,
                ),
              ),
              const Text("Blocks", style: TextStyle(fontSize: 20.0)),
              Padding(
                child: SpinBox(
                  value: block,
                  onChanged: (value) {
                    setState(() {
                      block = value;
                    });
                  },
                ),
                padding: const EdgeInsets.all(16),
              ),
              const Text("Turnovers", style: TextStyle(fontSize: 20.0)),
              Padding(
                child: SpinBox(
                  value: turnover,
                  onChanged: (value) {
                    setState(() {
                      turnover = value;
                    });
                  },
                ),
                padding: const EdgeInsets.all(16),
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text("Points", style: TextStyle(fontSize: 20.0)),
              CustomRadioButton(
                key: ValueKey(team),
                padding: 8,
                margin: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                elevation: 2,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  widget.game.team.name,
                  widget.game.opponent.name,
                ],
                buttonValues: [widget.game.team, widget.game.opponent],
                buttonTextStyle: const ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),
                radioButtonValue: (value) {
                  setState(() {
                    team = value as Team;
                  });
                },
                defaultSelected: team,
                selectedColor: Theme.of(context).primaryColor,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  key: const Key('submit'),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Submit', style: TextStyle(fontSize: 30)),
                  ),
                  onPressed: () {
                    _addScore();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void _addScore() {
    try {
      if (starting != null && team != null) {
        var score = Score(const Uuid().v4(), 1, DateTime.now(),
            turnover.toInt(), block.toInt(), starting!, team!, widget.game);
        scoreBox.add(score);
        AlertController.show("Success", "Score saved!", TypeAlert.success);
        _reset();
      } else {
        AlertController.show(
            "Error", "Please fill all the fields", TypeAlert.error);
      }
    } catch (e) {
      AlertController.show(
          "Error", "Please fill all the fields", TypeAlert.error);
    }
  }

  void _reset() {
    setState(() {
      starting = null;
      team = null;
      block = 0;
      turnover = 0;
    });
  }
}
