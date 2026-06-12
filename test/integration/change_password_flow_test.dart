import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultapp/presentation/viewmodels/change_password_viewmodel.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('ChangePasswordViewModel — integracao', () {
    group('ChangePasswordState', () {
      test('copyWith preserva campos nao alterados', () {
        const state = ChangePasswordState(
          currentPassword: 'old',
          newPassword: 'new12345',
          confirmPassword: 'new12345',
        );

        final newState = state.copyWith(isLoading: true);

        expect(newState.currentPassword, 'old');
        expect(newState.newPassword, 'new12345');
        expect(newState.confirmPassword, 'new12345');
        expect(newState.isLoading, true);
      });

      test('copyWith clearError remove mensagem de erro', () {
        const state = ChangePasswordState(
          errorMessage: 'Erro qualquer',
        );

        final newState = state.copyWith(clearError: true);

        expect(newState.errorMessage, isNull);
      });

      test('copyWith atualiza errorMessage', () {
        const state = ChangePasswordState();

        final newState = state.copyWith(errorMessage: 'Novo erro');

        expect(newState.errorMessage, 'Novo erro');
      });

      test('factory initial retorna estado padrao', () {
        final state = ChangePasswordState.initial();

        expect(state.currentPassword, '');
        expect(state.newPassword, '');
        expect(state.confirmPassword, '');
        expect(state.isLoading, false);
        expect(state.isSuccess, false);
        expect(state.errorMessage, isNull);
      });
    });

    group('ChangePasswordNotifier — update methods via ProviderContainer', () {
      test('estado inicial esta correto', () {
        final state = container.read(changePasswordProvider);

        expect(state.currentPassword, '');
        expect(state.newPassword, '');
        expect(state.confirmPassword, '');
        expect(state.isLoading, false);
        expect(state.isSuccess, false);
        expect(state.errorMessage, isNull);
      });

      test('updateCurrentPassword atualiza campo e limpa erro', () {
        container.read(changePasswordProvider.notifier).updateCurrentPassword(
              'minha_senha',
            );

        final state = container.read(changePasswordProvider);

        expect(state.currentPassword, 'minha_senha');
        expect(state.errorMessage, isNull);
      });

      test('updateNewPassword atualiza campo e limpa erro', () {
        container.read(changePasswordProvider.notifier).updateNewPassword(
              'nova_senha_123',
            );

        final state = container.read(changePasswordProvider);

        expect(state.newPassword, 'nova_senha_123');
        expect(state.errorMessage, isNull);
      });

      test('updateConfirmPassword atualiza campo e limpa erro', () {
        container
            .read(changePasswordProvider.notifier)
            .updateConfirmPassword('nova_senha_123');

        final state = container.read(changePasswordProvider);

        expect(state.confirmPassword, 'nova_senha_123');
        expect(state.errorMessage, isNull);
      });

      test('reset retorna ao estado inicial', () {
        final notifier = container.read(changePasswordProvider.notifier);

        notifier.updateCurrentPassword('old');
        notifier.updateNewPassword('new');
        notifier.updateConfirmPassword('new');
        notifier.reset();

        final state = container.read(changePasswordProvider);

        expect(state.currentPassword, '');
        expect(state.newPassword, '');
        expect(state.confirmPassword, '');
        expect(state.isLoading, false);
        expect(state.isSuccess, false);
      });
    });

    group('ChangePasswordNotifier — validateFields', () {
      test('validateFields retorna false com campos vazios', () {
        final notifier = container.read(changePasswordProvider.notifier);

        final result = notifier.validateFields();

        expect(result, false);
        final state = container.read(changePasswordProvider);
        expect(state.errorMessage, isNotNull);
      });

      test('validateFields retorna false com nova senha menor que 8 chars',
          () async {
        final notifier = container.read(changePasswordProvider.notifier);

        notifier.updateCurrentPassword('senha_atual');
        notifier.updateNewPassword('curta');
        notifier.updateConfirmPassword('curta');

        final result = notifier.validateFields();

        expect(result, false);
        final state = container.read(changePasswordProvider);
        expect(state.errorMessage, contains('8 caracteres'));
      });

      test('validateFields retorna false com senhas nao coincidentes', () {
        final notifier = container.read(changePasswordProvider.notifier);

        notifier.updateCurrentPassword('senha_atual');
        notifier.updateNewPassword('nova_senha_123');
        notifier.updateConfirmPassword('outra_senha');

        final result = notifier.validateFields();

        expect(result, false);
        final state = container.read(changePasswordProvider);
        expect(state.errorMessage, contains('coincidem'));
      });

      test('validateFields retorna true com dados validos', () {
        final notifier = container.read(changePasswordProvider.notifier);

        notifier.updateCurrentPassword('senha_atual');
        notifier.updateNewPassword('nova_senha_123');
        notifier.updateConfirmPassword('nova_senha_123');

        final result = notifier.validateFields();

        expect(result, true);
      });
    });
  });
}
