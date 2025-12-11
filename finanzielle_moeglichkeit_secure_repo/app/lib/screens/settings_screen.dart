
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool notifications = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            value: notifications,
            onChanged: (_) {},
            title: const Text('Benachrichtigungen'),
            subtitle: const Text('Infos zu neuen Inhalten & Angeboten'),
          ),
          const ListTile(
            title: Text('Datenschutz'),
            subtitle: Text('Wie wir mit deinen Daten umgehen'),
          ),
          const ListTile(
            title: Text('Impressum & Kontakt'),
          ),
        ],
      ),
    );
  }
}
