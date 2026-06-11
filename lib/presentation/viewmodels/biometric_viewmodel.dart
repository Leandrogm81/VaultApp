import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/services/biometric_service.dart';
import 'lock_viewmodel.dart';

/// Provider do BiometricNotifier.
final biometricProvider = NotifierProvider<BiometricNotifier, BiometricState>(() {
  return BiometricNotifier();
});

/// Estado de biometria.
class BiometricState {
  /// Se biometria esta disponivel no dispositivo.
  final bool isAvailable;

  /// Se esta autenticando.
  final bool isAuthenticating;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  /// Tipos de biometria disponiveis.
  final List<BiometricType> biometricTypes;

  /// Se a preferencia de biometria esta ativada.
  final bool isEnabled;

  const BiometricState({
    this.isAvailable = false,
    this.isAuthenticating = false,
    this.errorMessage,
    this.biometricTypes = const [],
    this.isEnabled = false,
  });

  factory BiometricState.initial() => const BiometricState();

  BiometricState copyWith({
    bool? isAvailable,
    bool? isAuthenticating,
    String? errorMessage,
    List<BiometricType>? biometricTypes,
    bool? isEnabled,
    bool clearError = false,
  }) {
    return BiometricState(
      isAvailable: isAvailable ?? this.isAvailable,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      biometricTypes: biometricTypes ?? this.biometricTypes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

/// ViewModel para biometria (Notifier do Riverpod 3.x).
///
/// Gerencia estado de biometria e integra BiometricService + Preference.
class BiometricNotifier extends Notifier<BiometricState> {
  @override
  BiometricState build() {
    return BiometricState.initial();
  }

  /// Verifica disponibilidade de biometria e preferencia.
  Future<void> checkAvailability() async {
    final biometricService = ref.read(biometricServiceProvider);
    final preferenceService = ref.read(biometricPreferenceServiceProvider);

    final isAvailable = await biometricService.isAvailable();
    final isEnabled = await preferenceService.isEnabled();
    final types = await biometricService.getAvailableTypes();

    state = state.copyWith(
      isAvailable: isAvailable,
      isEnabled: isEnabled,
      biometricTypes: types,
    );
  }

  /// Solicita autenticacao biometrica.
  Future<bool> authenticate() async {
    state = state.copyWith(isAuthenticating: true, clearError: true);

    final biometricService = ref.read(biometricServiceProvider);

    final result = await biometricService.authenticate();

    switch (result) {
      case BiometricSuccess():
        state = state.copyWith(isAuthenticating: false);
        return true;
      case BiometricFailure(reason: final reason):
        state = state.copyWith(
          isAuthenticating: false,
          errorMessage: reason,
        );
        return false;
      case BiometricUnavailable():
        state = state.copyWith(
          isAuthenticating: false,
          errorMessage: 'Biometria nao disponivel',
        );
        return false;
    }
  }

  /// Ativa preferencia de biometria.
  Future<void> enableBiometric() async {
    final preferenceService = ref.read(biometricPreferenceServiceProvider);
    await preferenceService.setEnabled(true);
    state = state.copyWith(isEnabled: true);
    await checkAvailability();
  }

  /// Desativa preferencia de biometria.
  Future<void> disableBiometric() async {
    final preferenceService = ref.read(biometricPreferenceServiceProvider);
    await preferenceService.setEnabled(false);
    state = state.copyWith(isEnabled: false);
  }
}
