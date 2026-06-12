import '../../domain/services/preferences_service.dart';

/// Servico de auto-lock timeout.
///
/// Gerencia a configuracao de timeout de bloqueio automatico do app.
/// Opcoes: 1, 2, 5, 10 minutos, ou nunca (0).
class AutoLockService {
  /// Opcoes de timeout disponiveis em minutos.
  /// 0 = nunca bloquear.
  static const List<int> timeoutOptions = [1, 2, 5, 10, 0];

  /// Timeout default: 2 minutos.
  static const int defaultTimeout = 2;

  /// Retorna o timeout atual em minutos.
  static Future<int> getTimeout(PreferencesService prefs) async {
    return await prefs.getAutoLockTimeout();
  }

  /// Salva o timeout de auto-lock.
  static Future<void> setTimeout(
    PreferencesService prefs,
    int minutes,
  ) async {
    await prefs.setAutoLockTimeout(minutes);
  }

  /// Retorna as opcoes de timeout disponiveis.
  static List<int> getTimeoutOptions() => timeoutOptions;

  /// Formata o timeout para exibicao.
  ///
  /// Exemplos: "1 min", "2 min", "5 min", "10 min", "Nunca".
  static String formatTimeout(int minutes) {
    if (minutes == 0) return 'Nunca';
    return '$minutes min';
  }
}
