import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/Constants.dart';
import 'package:matchpoint/models/team.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({Key? key}) : super(key: key);

  @override
  _AddTeamState createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final _key = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  late final Box box;

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    box = Hive.box<Team>(Constants.teams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add team"),
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _addTeams();
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

  void _addTeams() {
    var team =
        Team(_nameController.text, _descriptionController.text, DateTime.now());
    box.add(team);
  }
}
