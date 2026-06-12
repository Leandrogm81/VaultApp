import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/auth_service.dart';
import '../../domain/services/auto_wipe_service.dart';
import '../../domain/services/biometric_service.dart';
import '../../domain/services/crypto_service.dart';
import '../../domain/services/rate_limiting_service.dart';
import '../../domain/services/vault_state_service.dart';
import '../../data/daos/vault_state_dao.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/services/biometric_preference_service.dart';
import '../viewmodels/home_viewmodel.dart' show appDatabaseProvider;

/// Provider do AuthService (compartilhado entre telas).
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    crypto: ref.read(_cryptoServiceProvider),
    storage: ref.read(_storageServiceProvider),
  );
});

/// Provider do BiometricService.
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Provider do BiometricPreferenceService.
final biometricPreferenceServiceProvider =
    Provider<BiometricPreferenceService>((ref) {
  return BiometricPreferenceService();
});

/// Provider interno do CryptoService.
final _cryptoServiceProvider = Provider((ref) {
  return CryptoService();
});

/// Provider interno do SecureStorageService.
final _storageServiceProvider = Provider((ref) {
  return SecureStorageService();
});

/// Provider do VaultStateDao.
final vaultStateDaoProvider = Provider<VaultStateDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return VaultStateDao(db);
});

/// Provider do VaultStateService.
final vaultStateServiceProvider = Provider<VaultStateService>((ref) {
  return VaultStateService(ref.watch(vaultStateDaoProvider));
});

/// Provider do RateLimitingService.
final rateLimitingServiceProvider = Provider<RateLimitingService>((ref) {
  return RateLimitingService(ref.watch(vaultStateServiceProvider));
});

/// Provider do AutoWipeService.
final autoWipeServiceProvider = Provider<AutoWipeService>((ref) {
  return AutoWipeService(
    ref.watch(vaultStateServiceProvider),
  );
});

/// Provider do LockNotifier.
final lockProvider = NotifierProvider<LockNotifier, LockState>(() {
  return LockNotifier();
});

/// Modo de operacao da Lock Screen.
enum LockMode { setup, auth }

/// Estado da Lock Screen.
class LockState {
  /// Senha digitada pelo usuario.
  final String password;

  /// Se esta carregando.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  /// Modo de operacao (setup ou auth).
  final LockMode mode;

  /// Se o vault esta bloqueado por rate limiting.
  final bool isLockedOut;

  /// Timestamp de desbloqueio.
  final DateTime? lockUntil;

  /// Numero de tentativas falhas.
  final int failedAttempts;

  /// Se um auto-wipe foi executado (app deve navegar para onboarding).
  final bool wipeOccurred;

  const LockState({
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.mode = LockMode.auth,
    this.isLockedOut = false,
    this.lockUntil,
    this.failedAttempts = 0,
    this.wipeOccurred = false,
  });

  /// Estado inicial padrao.
  factory LockState.initial() => const LockState();

  /// Cria uma copia com campos alterados.
  LockState copyWith({
    String? password,
    bool? isLoading,
    String? errorMessage,
    LockMode? mode,
    bool? isLockedOut,
    DateTime? lockUntil,
    int? failedAttempts,
    bool? wipeOccurred,
    bool clearError = false,
    bool clearLockUntil = false,
  }) {
    return LockState(
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      mode: mode ?? this.mode,
      isLockedOut: isLockedOut ?? this.isLockedOut,
      lockUntil: clearLockUntil ? null : (lockUntil ?? this.lockUntil),
      failedAttempts: failedAttempts ?? this.failedAttempts,
      wipeOccurred: wipeOccurred ?? this.wipeOccurred,
    );
  }
}

/// ViewModel para a Lock Screen (Notifier do Riverpod 3.x).
///
/// Gerencia estado (senha, erro, loading, modo setup/auth, bloqueio)
/// e conecta UI ao Auth Service e RateLimitingService.
class LockNotifier extends Notifier<LockState> {
  /// Timer para desbloqueio automatico.
  Timer? _unlockTimer;

  @override
  LockState build() {
    return LockState.initial();
  }

  /// Verifica se e primeira vez e seta modo correspondente.
  Future<void> checkFirstTime() async {
    final authService = ref.read(authServiceProvider);
    final isFirstTime = await authService.isFirstTime();
    state = state.copyWith(
      mode: isFirstTime ? LockMode.setup : LockMode.auth,
    );

    // Verificar se ja esta bloqueado
    if (!isFirstTime) {
      await _checkLockStatus();
    }
  }

  /// Verifica o status de bloqueio atual.
  Future<void> _checkLockStatus() async {
    final rateLimiting = ref.read(rateLimitingServiceProvider);
    final result = await rateLimiting.checkLockStatus();

    if (result.isLocked) {
      state = state.copyWith(
        isLockedOut: true,
        lockUntil: result.lockUntil,
        failedAttempts: result.failedAttempts,
      );
      _startUnlockTimer();
    }
  }

  /// Envia a senha (setup ou auth dependendo do modo).
  Future<void> submitPassword() async {
    if (state.password.isEmpty) return;
    if (state.isLockedOut) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final authService = ref.read(authServiceProvider);
    final rateLimiting = ref.read(rateLimitingServiceProvider);
    final autoWipe = ref.read(autoWipeServiceProvider);

    try {
      if (state.mode == LockMode.setup) {
        await authService.setupPassword(state.password);
        state = state.copyWith(isLoading: false, password: '');
      } else {
        final result = await authService.authenticate(state.password);
        if (result is AuthSuccess) {
          // Login bem-sucedido: resetar rate limiting
          await rateLimiting.resetOnSuccess();
          state = state.copyWith(
            isLoading: false,
            password: '',
            failedAttempts: 0,
            clearLockUntil: true,
          );
        } else {
          // Login falhou: registrar tentativa
          final rateResult = await rateLimiting.recordFailedAttempt();

          // Verificar auto-wipe
          final wipeTriggered = await autoWipe.checkAndWipe(
            rateResult.failedAttempts,
          );

          if (wipeTriggered) {
            // Auto-wipe executado: navegar para onboarding
            state = state.copyWith(
              isLoading: false,
              password: '',
              wipeOccurred: true,
              mode: LockMode.setup,
              errorMessage: 'Dados apagados por seguranca. Configure sua senha novamente.',
              failedAttempts: 0,
              isLockedOut: false,
              clearLockUntil: true,
            );
            return;
          }

          if (rateResult.isLocked) {
            state = state.copyWith(
              isLoading: false,
              isLockedOut: true,
              lockUntil: rateResult.lockUntil,
              failedAttempts: rateResult.failedAttempts,
              errorMessage: 'Conta bloqueada. Tente novamente em ${rateResult.lockDurationMinutes} min.',
            );
            _startUnlockTimer();
          } else {
            final remaining = 5 - rateResult.failedAttempts;
            state = state.copyWith(
              isLoading: false,
              errorMessage: remaining > 0
                  ? 'Senha incorreta. $remaining tentativa(s) restante(s).'
                  : 'Senha incorreta',
              failedAttempts: rateResult.failedAttempts,
            );
          }
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao processar senha',
      );
    }
  }

  /// Inicia timer para desbloqueio automatico.
  void _startUnlockTimer() {
    _unlockTimer?.cancel();

    if (state.lockUntil == null) return;

    final remaining = state.lockUntil!.difference(DateTime.now());
    if (remaining.isNegative) {
      _unlock();
      return;
    }

    _unlockTimer = Timer(remaining, () {
      _unlock();
    });

    // Timer para atualizar a contagem regressiva
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.lockUntil == null || !state.isLockedOut) {
        timer.cancel();
        return;
      }

      final remaining = state.lockUntil!.difference(DateTime.now());
      if (remaining.isNegative) {
        timer.cancel();
        _unlock();
      } else {
        // Forca rebuild do widget para atualizar timer
        state = state.copyWith(lockUntil: state.lockUntil);
      }
    });
  }

  /// Desbloqueia o vault.
  void _unlock() {
    _unlockTimer?.cancel();
    state = state.copyWith(
      isLockedOut: false,
      clearLockUntil: true,
      clearError: true,
    );
  }

  /// Atualiza a senha digitada.
  void updatePassword(String password) {
    state = state.copyWith(password: password, clearError: true);
  }

  /// Limpa mensagem de erro.
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Disponiza timer ao destruir o notifier.
  void dispose() {
    _unlockTimer?.cancel();
  }
}
