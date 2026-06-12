import 'dart:async';
import 'package:flutter/services.dart';

/// Servico de clipboard com limpeza seletiva automatica.
///
/// Copia a senha para o clipboard e agenda limpeza apos timeout
/// (default: 30s). So limpa se o conteudo atual do clipboard
/// ainda for a senha que foi copiada.
///
/// Nao limpa se o usuario copiou outra coisa.
class ClipboardPasswordService {
  /// Valor da ultima senha copiada.
  String? _copiedPassword;

  /// Timer de limpeza automatica.
  Timer? _clearTimer;

  /// Timeout de limpeza em segundos.
  int _clearTimeoutSeconds = 30;

  /// Retorna o timeout atual em segundos.
  int getClearTimeout() => _clearTimeoutSeconds;

  /// Define o timeout de limpeza em segundos.
  void setClearTimeout(int seconds) {
    _clearTimeoutSeconds = seconds;
  }

  /// Copia a senha para o clipboard e agenda limpeza automatica.
  Future<void> copyPassword(String password) async {
    // Salvar valor copiado
    _copiedPassword = password;

    // Copiar para clipboard
    await Clipboard.setData(ClipboardData(text: password));

    // Cancelar timer anterior se existir
    _clearTimer?.cancel();

    // Agendar limpeza
    _clearTimer = Timer(Duration(seconds: _clearTimeoutSeconds), () {
      _autoClear();
    });
  }

  /// Cancela a limpeza automatica.
  void stopAutoClear() {
    _clearTimer?.cancel();
    _clearTimer = null;
  }

  /// Limpeza seletiva: so limpa se o conteudo atual for a senha copiada.
  Future<void> _autoClear() async {
    if (_copiedPassword == null) return;

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final currentContent = data?.text;

      // So limpa se o conteudo atual for a senha que copiamos
      if (currentContent == _copiedPassword) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    } catch (_) {
      // Clipboard pode nao estar disponivel em algumas plataformas
    }

    _copiedPassword = null;
  }

  /// Verifica se o clipboard contem a senha copiada.
  ///
  /// Util para testes e verificacao manual.
  Future<bool> clipboardHasCopiedPassword() async {
    if (_copiedPassword == null) return false;

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text == _copiedPassword;
    } catch (_) {
      return false;
    }
  }

  /// Limpa o timer e o valor copiado (usado no dispose).
  void dispose() {
    _clearTimer?.cancel();
    _clearTimer = null;
    _copiedPassword = null;
  }
}
