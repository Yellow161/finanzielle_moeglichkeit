
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../api/api_client.dart';

class LeadFormScreen extends StatefulWidget {
  const LeadFormScreen({super.key});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _ziel = '';
  bool _sending = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _sending = true);

    try {
      final res = await ApiClient.postRequest("/api/leads", {
        "name": _name,
        "email": _email,
        "ziel": _ziel,
      });

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Danke für deine Eintragung!')),
        );
        Navigator.pop(context);
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Fehler: ${body["error"] ?? res.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Netzwerkfehler: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eintragung'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (v) => _name = v?.trim() ?? '',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Bitte ausfüllen' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (v) => _email = v?.trim() ?? '',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Bitte E-Mail eingeben';
                    }
                    if (!v.contains('@')) return 'Bitte gültige E-Mail';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Was möchtest du verändern?',
                  ),
                  maxLines: 3,
                  onSaved: (v) => _ziel = v?.trim() ?? '',
                ),
                const Spacer(),
                PrimaryButton(
                  label: _sending ? 'Sende...' : 'Jetzt eintragen',
                  icon: Icons.send_rounded,
                  onPressed: _sending ? () {} : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
