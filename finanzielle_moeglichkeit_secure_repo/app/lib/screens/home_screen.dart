
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import 'lead_form_screen.dart';
import 'products_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanzielle Möglichkeit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text('Du möchtest dich verändern?', style: headlineStyle),
            const SizedBox(height: 8),
            const Text(
              'Starte heute – sichere dir Wissen, Routinen und Tools,
'
              'um deine finanzielle Situation zu verbessern.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Jetzt eintragen (Landingpage)',
              icon: Icons.edit_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LeadFormScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Digitale Produkte',
              subtitle: 'E-Books, Kurse und Vorlagen – sofort verfügbar.',
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductsScreen()),
                );
              },
            ),
            SectionCard(
              title: 'Support-Chat',
              subtitle: 'Stelle deine Fragen direkt im Chat.',
              trailing: const Icon(Icons.chat_bubble_outline_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
            ),
            SectionCard(
              title: 'Einstellungen & Profil',
              subtitle: 'Sprache, Benachrichtigungen, Datenschutz.',
              trailing: const Icon(Icons.tune_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
