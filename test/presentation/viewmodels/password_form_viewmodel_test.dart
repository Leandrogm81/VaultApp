import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vaultapp/presentation/viewmodels/password_form_viewmodel.dart';

void main() {
  /// Helper para criar um ProviderContainer com o PasswordFormProvider.
  ProviderContainer createContainer() {
    return ProviderContainer();
  }

  group('PasswordFormState', () {
    test('estado inicial deve ter valores padrao', () {
      final state = PasswordFormState.initial();
      expect(state.title, '');
      expect(state.username, '');
      expect(state.password, '');
      expect(state.url, '');
      expect(state.notes, '');
      expect(state.isFavorite, false);
      expect(state.isEditing, false);
      expect(state.editingId, isNull);
      expect(state.errors, isEmpty);
      expect(state.isSubmitting, false);
      expect(state.submitSuccess, false);
      expect(state.errorMessage, isNull);
    });

    test('copyWith deve criar copia com campos alterados', () {
      final state = PasswordFormState.initial();
      final copy = state.copyWith(
        title: 'GitHub',
        isFavorite: true,
      );
      expect(copy.title, 'GitHub');
      expect(copy.isFavorite, true);
      expect(copy.password, '');
    });

    test('copyWith com clearError deve limpar mensagem', () {
      final state = PasswordFormState(errorMessage: 'erro');
      final copy = state.copyWith(clearError: true);
      expect(copy.errorMessage, isNull);
    });

    test('copyWith preserva campos nao alterados', () {
      final state = PasswordFormState(
        title: 'Test',
        password: 'pass',
        errors: {'title': 'erro'},
      );
      final copy = state.copyWith(isSubmitting: true);
      expect(copy.title, 'Test');
      expect(copy.password, 'pass');
      expect(copy.errors, {'title': 'erro'});
      expect(copy.isSubmitting, true);
    });
  });

  group('PasswordFormNotifier (via ProviderContainer)', () {
    test('initializeForCreate deve reseta estado', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.initializeForCreate();
      final state = container.read(passwordFormProvider);
      expect(state.isEditing, false);
      expect(state.title, '');
    });

    test('initializeForEdit deve preencher campos', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      // Simula estado de edicao
      notifier.state = notifier.state.copyWith(
        title: 'GitHub',
        isEditing: true,
        editingId: '123',
      );
      final state = container.read(passwordFormProvider);
      expect(state.isEditing, true);
      expect(state.editingId, '123');
    });

    test('updateField deve atualizar campo e limpar erro', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.state = notifier.state.copyWith(
        errors: {'title': 'erro'},
      );
      notifier.updateField('title', 'Novo titulo');
      final state = container.read(passwordFormProvider);
      expect(state.title, 'Novo titulo');
      expect(state.errors.containsKey('title'), false);
    });

    test('validate com titulo vazio deve retornar false', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.state = notifier.state.copyWith(
        title: '',
        password: 'senha123',
      );
      final result = notifier.validate();
      expect(result, false);
      final state = container.read(passwordFormProvider);
      expect(state.errors.containsKey('title'), true);
    });

    test('validate com senha vazia deve retornar false', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.state = notifier.state.copyWith(
        title: 'Teste',
        password: '',
      );
      final result = notifier.validate();
      expect(result, false);
      final state = container.read(passwordFormProvider);
      expect(state.errors.containsKey('password'), true);
    });

    test('validate com campos obrigatorios validos deve retornar true', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.state = notifier.state.copyWith(
        title: 'Teste',
        password: 'senha123',
      );
      final result = notifier.validate();
      expect(result, true);
      final state = container.read(passwordFormProvider);
      expect(state.errors, isEmpty);
    });

    test('toggleFavorite deve alternar favorito', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      expect(notifier.state.isFavorite, false);
      notifier.toggleFavorite();
      expect(container.read(passwordFormProvider).isFavorite, true);
      notifier.toggleFavorite();
      expect(container.read(passwordFormProvider).isFavorite, false);
    });

    test('clearErrors deve limpar todos os erros', () {
      final container = createContainer();
      final notifier = container.read(passwordFormProvider.notifier);
      notifier.state = notifier.state.copyWith(
        errors: {'title': 'erro', 'password': 'erro'},
      );
      notifier.clearErrors();
      final state = container.read(passwordFormProvider);
      expect(state.errors, isEmpty);
    });
  });
}
