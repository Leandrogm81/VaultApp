import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../viewmodels/biometric_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/auto_lock_selector.dart';
import '../widgets/biometric_toggle.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_selector.dart';
import 'change_password_screen.dart';

/// Tela de Configuracoes do VaultApp.
///
/// Secoes: Tema, Auto-lock, Seguranca, Backup e Restauracao, Sobre.
/// Segue /docs/design/UI_UX_GUIDE.md.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadPreferences();
      ref.read(themeProvider.notifier).loadTheme();
      ref.read(biometricProvider.notifier).checkAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final themeState = ref.watch(themeProvider);
    final biometricState = ref.watch(biometricProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracoes'),
      ),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Secao Tema
                SettingsSection(
                  title: 'Tema',
                  child: ThemeSelector(
                    currentPreference: themeState.preference,
                    onChanged: (value) {
                      ref.read(themeProvider.notifier).setTheme(value);
                      ref.read(settingsProvider.notifier).setTheme(value);
                    },
                  ),
                ),

                // Secao Auto-lock
                SettingsSection(
                  title: 'Auto-lock',
                  child: AutoLockSelector(
                    currentTimeout: settingsState.autoLockTimeout,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .setAutoLockTimeout(value);
                    },
                  ),
                ),

                // Secao Seguranca
                SettingsSection(
                  title: 'Seguranca',
                  child: Column(
                    children: [
                      BiometricToggle(
                        value: biometricState.isEnabled,
                        isAvailable: biometricState.isAvailable,
                        onChanged: (value) async {
                          if (value) {
                            await ref
                                .read(biometricProvider.notifier)
                                .enableBiometric();
                          } else {
                            await ref
                                .read(biometricProvider.notifier)
                                .disableBiometric();
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.lock_outline_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: const Text(
                          'Alterar senha mestra',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        dense: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Secao Backup e Restauracao
                SettingsSection(
                  title: 'Backup e Restauracao',
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.cloud_upload_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: const Text(
                          'Fazer backup',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          'Sprint 12',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        dense: true,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.cloud_download_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: const Text(
                          'Restaurar backup',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          'Sprint 13',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        dense: true,
                      ),
                    ],
                  ),
                ),

                // Secao Sobre
                SettingsSection(
                  title: 'Sobre',
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        title: const Text(
                          'VaultApp',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          'Versao 1.0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        dense: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
    );
  }
}
