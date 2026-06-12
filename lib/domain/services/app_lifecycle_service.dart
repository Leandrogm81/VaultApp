import 'package:flutter/material.dart';

import '../../domain/services/preferences_service.dart';
import '../../domain/services/vault_state_service.dart';

/// Servico de auto-lock que bloqueia o app apos timeout de inatividade.
///
/// Detecta quando o app vai para background e verifica se o timeout
/// expirou quando o app volta para foreground. Usa WidgetsBindingObserver.
class AppLifecycleService with WidgetsBindingObserver {
  final VaultStateService _vaultState;
  final PreferencesService _prefs;

  /// Timestamp de quando o app foi para background.
  DateTime? _backgroundTime;

  /// Se o auto-lock esta habilitado.
  bool _enabled = true;

  /// Callback chamado quando o app deve ser bloqueado.
  VoidCallback? onLockRequired;

  AppLifecycleService(this._vaultState, this._prefs) {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Retorna o timeout atual em minutos.
  Future<int> getTimeout() async {
    return await _prefs.getAutoLockTimeout();
  }

  /// Salva o timeout de auto-lock em minutos.
  Future<void> setTimeout(int minutes) async {
    await _prefs.setAutoLockTimeout(minutes);
  }

  /// Verifica se o auto-lock esta habilitado (timeout > 0).
  Future<bool> isAutoLockEnabled() async {
    final timeout = await getTimeout();
    return timeout > 0;
  }

  /// Habilita ou desabilita o auto-lock.
  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Chamado quando o app vai para background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_enabled) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _onBackground();
        break;
      case AppLifecycleState.resumed:
        _onForeground();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// Registra timestamp quando app vai para background.
  void _onBackground() {
    _backgroundTime = DateTime.now();
  }

  /// Verifica se timeout expirou quando app volta para foreground.
  Future<void> _onForeground() async {
    if (_backgroundTime == null) return;

    final timeoutMinutes = await getTimeout();
    if (timeoutMinutes == 0) {
      // Auto-lock desabilitado (timeout = 0 = "nunca")
      _backgroundTime = null;
      return;
    }

    final elapsed = DateTime.now().difference(_backgroundTime!);
    _backgroundTime = null;

    if (elapsed.inMinutes >= timeoutMinutes) {
      // Timeout expirou: bloquear app
      await _lockApp();
    }
  }

  /// Bloqueia o app.
  Future<void> _lockApp() async {
    // Definir bloqueio imediato (lock_until = agora)
    // O VaultStateService.isLocked() verifica lock_until > agora
    // Para bloqueio imediato, usamos um timestamp minimo no passado
    // que sera limpo quando o usuario desbloquear
    await _vaultState.clearLock();
    onLockRequired?.call();
  }

  /// Registra manualmente que o app foi para background.
  ///
  /// Util para teste manual ou integracao com outros lifecycle hooks.
  void notifyBackground() {
    _onBackground();
  }

  /// Registra manualmente que o app voltou para foreground.
  ///
  /// Util para teste manual.
  Future<void> notifyForeground() async {
    await _onForeground();
  }

  /// Dispoe o observer.
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
