import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../viewmodels/lock_viewmodel.dart' as vm;
import '../viewmodels/biometric_viewmodel.dart';
import '../widgets/biometric_button.dart';

/// Tela de bloqueio do VaultApp.
///
/// Primeira tela que o usuario ve. Segue UI_UX_GUIDE.md.
/// Estados: setup (primeira vez), auth, loading, erro.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // Verificar se e primeira vez apos build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vm.lockProvider.notifier).checkFirstTime();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vm.lockProvider);
    final isSetup = state.mode == vm.LockMode.setup;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fundo do guia
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/nome do app
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: Color(0xFF1D4ED8), // Primaria do guia
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'VaultApp',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A), // Texto principal do guia
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSetup
                        ? 'Defina sua senha mestra'
                        : 'Digite sua senha mestra',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF475569), // Texto secundario do guia
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botao de biometria (apenas no modo auth e se disponivel)
                  if (!isSetup) ...[
                    Consumer(
                      builder: (context, ref, child) {
                        final biometricState = ref.watch(biometricProvider);
                        if (biometricState.isAvailable && biometricState.isEnabled) {
                          return Column(
                            children: [
                              BiometricButton(
                                isLoading: biometricState.isAuthenticating,
                                isFaceId: biometricState.biometricTypes
                                    .contains(BiometricType.face),
                                onPressed: () async {
                                  final success = await ref
                                      .read(biometricProvider.notifier)
                                      .authenticate();
                                  if (success && context.mounted) {
                                    // Desbloquear — fluxo futuro
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Ou use sua biometria',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],

                  // Campo de senha
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    onChanged: (value) {
                      ref.read(vm.lockProvider.notifier).updatePassword(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), // Raio do guia
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),

                  // Mensagem de erro
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFB91C1C), // Erro do guia
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Botao principal
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: state.isLoading || state.password.isEmpty
                          ? null
                          : () async {
                              await ref
                                  .read(vm.lockProvider.notifier)
                                  .submitPassword();
                              _passwordController.clear();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8), // Primaria
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF1D4ED8).withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isSetup ? 'Criar senha' : 'Desbloquear',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),

                  // Link "Esqueci a senha" (placeholder)
                  if (!isSetup) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Placeholder — fluxo completo na Sprint 14
                      },
                      child: const Text(
                        'Esqueci a senha',
                        style: TextStyle(
                          color: Color(0xFF64748B), // Texto discreto do guia
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
