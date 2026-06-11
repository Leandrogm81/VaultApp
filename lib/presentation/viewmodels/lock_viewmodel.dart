import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/auth_service.dart';
import '../../domain/services/biometric_service.dart';
import '../../domain/services/crypto_service.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/services/biometric_preference_service.dart';

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
final biometricPreferenceServiceProvider = Provider<BiometricPreferenceService>((ref) {
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

  const LockState({
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.mode = LockMode.auth,
  });

  /// Estado inicial padrao.
  factory LockState.initial() => const LockState();

  /// Cria uma copia com campos alterados.
  LockState copyWith({
    String? password,
    bool? isLoading,
    String? errorMessage,
    LockMode? mode,
    bool clearError = false,
  }) {
    return LockState(
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      mode: mode ?? this.mode,
    );
  }
}

/// ViewModel para a Lock Screen (Notifier do Riverpod 3.x).
///
/// Gerencia estado (senha, erro, loading, modo setup/auth)
/// e conecta UI ao Auth Service.
class LockNotifier extends Notifier<LockState> {
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
  }

  /// Envia a senha (setup ou auth dependendo do modo).
  Future<void> submitPassword() async {
    if (state.password.isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final authService = ref.read(authServiceProvider);

    try {
      if (state.mode == LockMode.setup) {
        await authService.setupPassword(state.password);
        state = state.copyWith(isLoading: false, password: '');
      } else {
        final result = await authService.authenticate(state.password);
        if (result is AuthSuccess) {
          state = state.copyWith(isLoading: false, password: '');
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Senha incorreta',
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao processar senha',
      );
    }
  }

  /// Atualiza a senha digitada.
  void updatePassword(String password) {
    state = state.copyWith(password: password, clearError: true);
  }

  /// Limpa mensagem de erro.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
