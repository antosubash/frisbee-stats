import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matchpoint/Constants.dart';
import 'package:matchpoint/components/team/add_teams.dart';
import 'package:matchpoint/models/team.dart';

class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTeam()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Team>(Constants.teams).listenable(),
        builder: (context, Box<Team> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No Teams"),
            );
          }
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Team? team = box.getAt(index);
                return InkWell(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Team"),
                        content: const Text(
                            "Are you sure you want to delete this team?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              box.deleteAt(index);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Delete"),
                          ),
                        ],
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
                          children: [Text(team!.name), Text(team.description)],
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
