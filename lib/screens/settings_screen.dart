import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _currentMode;

  @override
  void initState() {
    super.initState();
    loadThemeData();
  }

  void loadThemeData() {
    final mode = context.read<ThemeProvider>().themeMode;
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Избор на тема',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _themeOption('Светла тема', ThemeMode.light),
          _themeOption('Тъмна тема', ThemeMode.dark),
          _themeOption('Системна тема', ThemeMode.system),
        ],
      ),
    );
  }

  void _onThemeChanged(ThemeMode newMode) {
    context.read<ThemeProvider>().setTheme(newMode);
    setState(() => _currentMode = newMode);
  }

  Widget _themeOption(String label, ThemeMode mode) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: _currentMode,
      onChanged: (val) => _onThemeChanged(val!),
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}
