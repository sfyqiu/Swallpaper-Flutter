import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/app_state.dart';
import '../../services/localization_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.of(context);

    return GlassAtmosphereBackground(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(loc.tr('nav.settings'), style: Theme.of(context).textTheme.headlineMedium),
          ),
          const SizedBox(height: 12),

          // Settings tabs
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _SettingsTab(label: loc.tr('settings.general'), icon: Icons.tune),
                _SettingsTab(label: loc.tr('settings.download'), icon: Icons.download),
                _SettingsTab(label: loc.tr('settings.workshop'), icon: Icons.extension),
                _SettingsTab(label: loc.tr('settings.scheduler'), icon: Icons.schedule),
                _SettingsTab(label: loc.tr('settings.cloudSync'), icon: Icons.cloud_sync),
                _SettingsTab(label: loc.tr('settings.about'), icon: Icons.info),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _GeneralSettings(loc: loc),
                _DownloadSettings(loc: loc),
                _WorkshopSettings(loc: loc),
                _SchedulerSettings(loc: loc),
                _CloudSyncSettings(loc: loc),
                _AboutSettings(loc: loc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SettingsTab({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
        selected: false,
        onSelected: (_) {},
        showCheckmark: false,
        backgroundColor: AppColors.glassTint,
        selectedColor: AppColors.primaryPink.withValues(alpha: 0.3),
      ),
    );
  }
}

class _GeneralSettings extends StatelessWidget {
  final LocalizationService loc;
  const _GeneralSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionTitle('Language / 语言 / 言語'),
        const SizedBox(height: 8),
        _SettingTile(
          title: 'English',
          subtitle: 'Switch to English',
          trailing: const Icon(Icons.check, color: AppColors.primaryPink, size: 20),
        ),
        _SettingTile(title: '中文', subtitle: '切换到中文'),
        _SettingTile(title: '日本語', subtitle: '日本語に切り替え'),
        const Divider(height: 32, color: AppColors.borderSubtle),

        _SectionTitle('API Keys'),
        const SizedBox(height: 8),
        ...['Wallhaven', 'Unsplash', 'Pexels'].map((s) => _ApiKeyTile(sourceName: s, state: context.read<AppState>())),
        const Divider(height: 32, color: AppColors.borderSubtle),

        _SectionTitle('Connection'),
        const SizedBox(height: 8),
        GlassButton(
          label: loc.tr('settings.testConnection'),
          icon: Icons.wifi_find,
          color: AppColors.onlineGreen.withValues(alpha: 0.3),
          onTap: () {},
        ),
      ],
    );
  }
}

class _DownloadSettings extends StatelessWidget {
  final LocalizationService loc;
  const _DownloadSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SettingTile(
          title: 'Save to Downloads',
          subtitle: 'Automatically save downloads',
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
        _SettingTile(
          title: 'Download Path',
          subtitle: '/Downloads/Swallpaper',
          trailing: const Icon(Icons.folder_open, color: AppColors.textSecondary),
        ),
        _SettingTile(
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          onTap: () {},
        ),
      ],
    );
  }
}

class _WorkshopSettings extends StatelessWidget {
  final LocalizationService loc;
  const _WorkshopSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SettingTile(title: 'SteamCMD Path', subtitle: 'Not configured', trailing: Icon(Icons.folder_open, color: AppColors.textSecondary)),
        _SettingTile(title: 'Wallpaper Engine Path', subtitle: 'Not configured', trailing: Icon(Icons.folder_open, color: AppColors.textSecondary)),
        _SettingTile(title: 'Show All Content', subtitle: 'Including mature content', trailing: Switch(value: false, onChanged: (_) {})),
      ],
    );
  }
}

class _SchedulerSettings extends StatelessWidget {
  final LocalizationService loc;
  const _SchedulerSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SettingTile(title: 'Wallpaper Rotation', subtitle: 'Change wallpaper periodically', trailing: Switch(value: false, onChanged: (_) {})),
        _SettingTile(title: 'Interval', subtitle: 'Every 1 hour'),
        _SettingTile(title: 'Source', subtitle: 'From Favorites'),
        _SettingTile(title: 'Shuffle', subtitle: 'Random order', trailing: Switch(value: false, onChanged: (_) {})),
      ],
    );
  }
}

class _CloudSyncSettings extends StatelessWidget {
  final LocalizationService loc;
  const _CloudSyncSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SettingTile(title: 'Cloud Sync', subtitle: 'Sync library across devices', trailing: Switch(value: false, onChanged: (_) {})),
        _SettingTile(title: 'Provider', subtitle: 'OneDrive / iCloud / Dropbox'),
        _SettingTile(title: 'Sync Folder', subtitle: 'Not selected', trailing: Icon(Icons.folder_open, color: AppColors.textSecondary)),
        GlassButton(label: 'Scan Library', color: AppColors.tertiaryBlue.withValues(alpha: 0.3), onTap: () {}),
        const SizedBox(height: 8),
        GlassButton(label: 'Migrate Library', color: AppColors.warningOrange.withValues(alpha: 0.3), onTap: () {}),
      ],
    );
  }
}

class _AboutSettings extends StatelessWidget {
  final LocalizationService loc;
  const _AboutSettings({required this.loc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Icon(Icons.wallpaper, color: AppColors.primaryPink, size: 40),
              ),
              const SizedBox(height: 12),
              Text('Swallpaper', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('v1.0.0', style: TextStyle(color: AppColors.textTertiary)),
              const SizedBox(height: 4),
              Text('Cross-platform wallpaper manager', style: TextStyle(color: AppColors.textQuaternary, fontSize: 12)),
              const SizedBox(height: 20),
              GlassButton(label: loc.tr('settings.checkUpdate'), icon: Icons.system_update, color: AppColors.tertiaryBlue.withValues(alpha: 0.3), onTap: () {}),
            ],
          ),
        ),
        const Divider(height: 32, color: AppColors.borderSubtle),
        _SettingTile(title: 'GitHub', subtitle: 'github.com/sfyqiu/Swallpaper-Flutter', trailing: Icon(Icons.open_in_new, color: AppColors.textSecondary, size: 18)),
        _SettingTile(title: 'License', subtitle: 'GNU GPL v3.0'),
      ],
    );
  }
}

// Reusable components
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(color: AppColors.primaryPink, fontSize: 13, fontWeight: FontWeight.w600));
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({required this.title, required this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _ApiKeyTile extends StatelessWidget {
  final String sourceName;
  final AppState state;
  const _ApiKeyTile({required this.sourceName, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(sourceName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
      subtitle: Text('Tap to enter API key', style: TextStyle(color: AppColors.textTertiary, fontSize: 12)),
      trailing: const Icon(Icons.key, color: AppColors.textSecondary, size: 20),
      onTap: () => _showKeyDialog(context, sourceName, state),
    );
  }

  void _showKeyDialog(BuildContext context, String source, AppState state) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceBackground,
        title: Text('$source API Key', style: const TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter your API key',
            hintStyle: TextStyle(color: AppColors.textTertiary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.small), borderSide: BorderSide.none),
            filled: true, fillColor: AppColors.glassTint,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                state.setApiKey(source, controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save', style: TextStyle(color: AppColors.primaryPink)),
          ),
        ],
      ),
    );
  }
}
