import 'package:flutter/material.dart';
import 'app_colors.dart' as AppColors;

class SettingsScreen extends StatefulWidget {
  final void Function(bool isDarkMode) toggleDarkMode;
  final bool isDarkMode;
  const SettingsScreen({
    super.key,
    required this.toggleDarkMode,
    required this.isDarkMode,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  String _selectedLanguage = 'English';
  bool _isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.menu1Color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    _isDarkMode = value;
                    widget.toggleDarkMode(value);
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['English', 'Urdu', 'Spanish', 'French']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
