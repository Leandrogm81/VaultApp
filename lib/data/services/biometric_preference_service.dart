import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servico de persistencia da preferencia de biometria.
///
/// Armazena se o usuario ativou biometria e se ja viu o prompt.
/// Usa flutter_secure_storage para persistencia segura.
class BiometricPreferenceService {
  final FlutterSecureStorage _storage;

  static const String _enabledKey = 'biometric_enabled';
  static const String _promptSeenKey = 'biometric_prompt_seen';

  BiometricPreferenceService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Verifica se biometria esta ativada.
  Future<bool> isEnabled() async {
    final value = await _storage.read(key: _enabledKey);
    return value == 'true';
  }

  /// Ativa ou desativa biometria.
  Future<void> setEnabled(bool value) async {
    await _storage.write(key: _enabledKey, value: value.toString());
  }

  /// Verifica se o usuario ja viu o prompt de biometria.
  Future<bool> hasSeenBiometricPrompt() async {
    final value = await _storage.read(key: _promptSeenKey);
    return value == 'true';
  }

  /// Marca que o usuario ja viu o prompt de biometria.
  Future<void> setSeenBiometricPrompt() async {
    await _storage.write(key: _promptSeenKey, value: 'true');
  }
}
