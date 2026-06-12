import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/crypto_service.dart';
import '../../domain/services/change_password_service.dart';
import '../viewmodels/home_viewmodel.dart' show passwordDaoProvider;

/// Provider do ChangePasswordNotifier.
final changePasswordProvider =
    NotifierProvider<ChangePasswordNotifier, ChangePasswordState>(() {
  return ChangePasswordNotifier();
});

/// Estado da tela de alteracao de senha.
class ChangePasswordState {
  /// Senha atual digitada pelo usuario.
  final String currentPassword;

  /// Nova senha digitada pelo usuario.
  final String newPassword;

  /// Confirmacao da nova senha.
  final String confirmPassword;

  /// Se esta processando.
  final bool isLoading;

  /// Se a alteracao foi bem-sucedida.
  final bool isSuccess;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  const ChangePasswordState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  /// Estado inicial padrao.
  factory ChangePasswordState.initial() => const ChangePasswordState();

  /// Cria uma copia com campos alterados.
  ChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel para a tela de alteracao de senha mestra (Notifier do Riverpod 3.x).
///
/// Gerencia estado: campos, validacao, loading, erro, sucesso.
/// Conecta UI ao ChangePasswordService.
class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() {
    return ChangePasswordState.initial();
  }

  /// Atualiza a senha atual digitada.
  void updateCurrentPassword(String value) {
    state = state.copyWith(currentPassword: value, clearError: true);
  }

  /// Atualiza a nova senha digitada.
  void updateNewPassword(String value) {
    state = state.copyWith(newPassword: value, clearError: true);
  }

  /// Atualiza a confirmacao da nova senha.
  void updateConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value, clearError: true);
  }

  /// Valida os campos do formulario.
  ///
  /// Retorna true se todos os campos sao validos.
  bool validateFields() {
    final errors = <String, String>{};

    if (state.currentPassword.isEmpty) {
      errors['currentPassword'] = 'Senha atual e obrigatoria';
    }

    if (state.newPassword.isEmpty) {
      errors['newPassword'] = 'Nova senha e obrigatoria';
    } else if (state.newPassword.length < 8) {
      errors['newPassword'] = 'Nova senha deve ter no minimo 8 caracteres';
    }

    if (state.confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Confirmacao e obrigatoria';
    } else if (state.confirmPassword != state.newPassword) {
      errors['confirmPassword'] = 'Senhas nao coincidem';
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(
        errorMessage: errors.values.first,
      );
      return false;
    }

    return true;
  }

  /// Executa a alteracao de senha.
  Future<void> changePassword() async {
    if (!validateFields()) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final service = ref.read(_changePasswordServiceProvider);
      final result = await service.changePassword(
        state.currentPassword,
        state.newPassword,
      );

      if (result) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Falha ao alterar senha',
        );
      }
    } on InvalidCurrentPasswordException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Senha atual incorreta',
      );
    } on ChangePasswordFailedException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao alterar senha',
      );
    }
  }

  /// Reseta o estado para o inicial.
  void reset() {
    state = ChangePasswordState.initial();
  }
}

/// Provider interno do CryptoService (mesmo do lock_viewmodel).
final _cryptoProvider = Provider((ref) {
  return CryptoService();
});

/// Provider interno do FlutterSecureStorage (mesmo do lock_viewmodel).
final _secureStorageProvider = Provider((ref) {
  return const FlutterSecureStorage();
});

/// Provider do ChangePasswordService.
final _changePasswordServiceProvider = Provider<ChangePasswordService>((ref) {
  return ChangePasswordService(
    crypto: ref.read(_cryptoProvider),
    passwordDao: ref.read(passwordDaoProvider),
    secureStorage: ref.read(_secureStorageProvider),
  );
});
