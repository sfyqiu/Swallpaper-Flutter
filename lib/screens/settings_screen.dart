import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../services/localization_service.dart';
import '../config/api_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tr('settings')),
      ),
      body: ListView(
        children: [
          // API Keys Section
          _buildSection(
            context,
            title: loc.tr('apiKey'),
            icon: Icons.key,
            children: [
              _buildApiKeyTile(
                context,
                sourceName: 'Wallhaven',
                icon: Icons.language,
              ),
              _buildApiKeyTile(
                context,
                sourceName: 'Unsplash',
                icon: Icons.image,
              ),
              _buildApiKeyTile(
                context,
                sourceName: 'Pexels',
                icon: Icons.video_library,
              ),
            ],
          ),

          // Appearance Section
          _buildSection(
            context,
            title: loc.tr('theme'),
            icon: Icons.palette,
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                subtitle: const Text('Follow system settings'),
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),

          // Language Section
          _buildSection(
            context,
            title: loc.tr('language'),
            icon: Icons.translate,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                trailing: const Icon(Icons.check),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('中文'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('日本語'),
                onTap: () {},
              ),
            ],
          ),

          // About Section
          _buildSection(
            context,
            title: loc.tr('about'),
            icon: Icons.info,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Swallpaper'),
                subtitle: const Text('v1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Open Source'),
                subtitle: const Text(ApiConfig.repoUrl),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildApiKeyTile(
    BuildContext context, {
    required String sourceName,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(sourceName),
      subtitle: Text('Enter API Key'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showApiKeyDialog(context, sourceName),
    );
  }

  void _showApiKeyDialog(BuildContext context, String sourceName) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$sourceName API Key'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your API key',
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context
                    .read<WallpaperProvider>()
                    .setApiKey(sourceName, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
