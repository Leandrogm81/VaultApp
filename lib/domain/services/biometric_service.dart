import 'package:local_auth/local_auth.dart';

/// Resultado de uma operacao de autenticacao biometrica.
sealed class BiometricResult {
  const BiometricResult();
}

/// Autenticacao bem-sucedida.
class BiometricSuccess extends BiometricResult {
  const BiometricSuccess();
}

/// Autenticacao falhou.
class BiometricFailure extends BiometricResult {
  final String reason;
  const BiometricFailure(this.reason);
}

/// Biometria nao disponivel no dispositivo.
class BiometricUnavailable extends BiometricResult {
  const BiometricUnavailable();
}

/// Servico de autenticacao biometrica.
///
/// Encapsula local_auth para verificar disponibilidade
/// e solicitar autenticacao biometrica.
class BiometricService {
  final LocalAuthentication _localAuth;

  BiometricService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  /// Verifica se o dispositivo suporta biometria.
  Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Solicita autenticacao biometrica.
  Future<BiometricResult> authenticate() async {
    try {
      final available = await isAvailable();
      if (!available) {
        return const BiometricUnavailable();
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Desbloqueie o VaultApp',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        return const BiometricSuccess();
      }
      return const BiometricFailure('Autenticacao falhou');
    } catch (e) {
      return BiometricFailure('Erro: ${e.toString()}');
    }
  }

  /// Retorna os tipos de biometria disponiveis no dispositivo.
  Future<List<BiometricType>> getAvailableTypes() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
}
