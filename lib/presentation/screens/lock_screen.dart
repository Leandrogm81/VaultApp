import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../viewmodels/lock_viewmodel.dart' as vm;
import '../viewmodels/biometric_viewmodel.dart';
import '../widgets/biometric_button.dart';

/// Tela de bloqueio do VaultApp.
///
/// Primeira tela que o usuario ve. Segue UI_UX_GUIDE.md.
/// Estados: setup (primeira vez), auth, loading, erro, bloqueio.
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

  /// Formata o tempo restante de bloqueio como MM:SS.
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vm.lockProvider);
    final isSetup = state.mode == vm.LockMode.setup;
    final isLockedOut = state.isLockedOut;

    // Calcular tempo restante
    String? remainingTime;
    if (isLockedOut && state.lockUntil != null) {
      final remaining = state.lockUntil!.difference(DateTime.now());
      if (remaining.isNegative) {
        remainingTime = '00:00';
      } else {
        remainingTime = _formatDuration(remaining);
      }
    }

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

                  // Texto contextual
                  if (isLockedOut)
                    Text(
                      'Conta bloqueada',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB91C1C), // Erro do guia
                      ),
                    )
                  else
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

                  // Timer de bloqueio (quando bloqueado)
                  if (isLockedOut && remainingTime != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2), // Fundo erro leve
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFB91C1C).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.timer_off_outlined,
                            size: 32,
                            color: Color(0xFFB91C1C),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tente novamente em',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            remainingTime,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB91C1C),
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.failedAttempts} tentativa(s) falha(s)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Botao de biometria (apenas no modo auth, disponivel e NAO bloqueado)
                  if (!isSetup && !isLockedOut) ...[
                    Consumer(
                      builder: (context, ref, child) {
                        final biometricState = ref.watch(biometricProvider);
                        if (biometricState.isAvailable &&
                            biometricState.isEnabled) {
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

                  // Campo de senha (desabilitado quando bloqueado)
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    enabled: !isLockedOut,
                    onChanged: (value) {
                      ref.read(vm.lockProvider.notifier).updatePassword(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: isLockedOut
                          ? 'Conta bloqueada'
                          : 'Digite sua senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: isLockedOut
                            ? null
                            : () {
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

                  // Botao principal (desabilitado quando bloqueado)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: (state.isLoading ||
                              state.password.isEmpty ||
                              isLockedOut)
                          ? null
                          : () async {
                              await ref
                                  .read(vm.lockProvider.notifier)
                                  .submitPassword();
                              _passwordController.clear();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF1D4ED8).withValues(alpha: 0.5),
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
                      onPressed: isLockedOut
                          ? null
                          : () {
                              // Placeholder — fluxo completo na Sprint 14
                            },
                      child: const Text(
                        'Esqueci a senha',
                        style: TextStyle(
                          color: Color(0xFF64748B),
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
