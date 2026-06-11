import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/biometric_viewmodel.dart';
import '../widgets/biometric_toggle.dart';

/// Tela minima de Configuracoes.
///
/// Apenas secao de Segurança com toggle de biometria.
/// Tela completa sera implementada na Sprint 9.
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
      ref.read(biometricProvider.notifier).checkAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    final biometricState = ref.watch(biometricProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListView(
        children: [
          // Secao Seguranca
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'SEGURANÇA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: BiometricToggle(
              value: biometricState.isEnabled,
              isAvailable: biometricState.isAvailable,
              onChanged: (value) async {
                if (value) {
                  await ref.read(biometricProvider.notifier).enableBiometric();
                } else {
                  await ref.read(biometricProvider.notifier).disableBiometric();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
