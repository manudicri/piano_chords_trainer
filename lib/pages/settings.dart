import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  final String title = "Settings";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

enum NotesNaming {
  ABCNotation,
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: SettingsList(
        backgroundColor: Colors.white,
        sections: [
          SettingsSection(
            titlePadding: const EdgeInsets.only(left: 15, top: 20),
            title: "View mode",
            tiles: [
              SettingsTile(
                title: "Notes naming",
                subtitle: "",
                leading: Icon(Icons.music_note),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: "Chords form",
                leading: Icon(Icons.piano),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      contentPadding: EdgeInsets.all(10),
                      title: Text("Chords form"),
                      content: Container(
                        width: 300.0,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              title: Text("Long"),
                              subtitle: Text("maj,min,aug,dim"),
                              onTap: () {},
                            ),
                            ListTile(
                              title: Text("Short"),
                              subtitle: Text("M,m,-,+,°"),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          SettingsSection(
            titlePadding: const EdgeInsets.only(left: 15, top: 20),
            title: "User data",
            tiles: [
              SettingsTile(
                title: "Delete all data",
                subtitle: "Reset progress",
                leading: Icon(Icons.delete),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      return AlertDialog(
                        title:
                            Text("Are you sure you want to delete all data?"),
                        content: Text(
                            "There won't be much to lose.\nEach level will return to having 0 stars."),
                        actions: [
                          TextButton(
                            child: Text('ANNULLA'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text("OK"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Data deleted"),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
