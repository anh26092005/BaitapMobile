import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable notifications'),
            value: notifications,
            onChanged: (v) => setState(() => notifications = v),
          ),
          SwitchListTile(
            title: const Text('Dark mode (local)'),
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
          ),
          const ListTile(
            title: Text('About'),
            subtitle: Text('UTH SmartTasks sample UI'),
          ),
        ],
      ),
    );
  }
}

