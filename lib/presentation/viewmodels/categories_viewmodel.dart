import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_viewmodel.dart';
import '../../data/daos/category_dao.dart';
import '../../domain/services/category_service.dart';

/// Provider do CategoryDao.
final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.read(appDatabaseProvider);
  return CategoryDao(db);
});

/// Provider do CategoryService.
final categoryServiceProvider = Provider<CategoryService>((ref) {
  final categoryDao = ref.read(categoryDaoProvider);
  final passwordDao = ref.read(passwordDaoProvider);
  return CategoryService(categoryDao, passwordDao);
});

/// Provider do CategoriesNotifier.
final categoriesProvider =
    NotifierProvider<CategoriesNotifier, CategoriesState>(() {
  return CategoriesNotifier();
});

/// Estado da tela de categorias.
class CategoriesState {
  /// Lista de categorias com contagem.
  final List<CategoryWithCount> categories;

  /// Se esta carregando.
  final bool isLoading;

  /// Mensagem de erro (null quando nao ha erro).
  final String? errorMessage;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Estado inicial padrao.
  factory CategoriesState.initial() => const CategoriesState();

  /// Cria uma copia com campos alterados.
  CategoriesState copyWith({
    List<CategoryWithCount>? categories,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ViewModel para a tela de categorias (Notifier do Riverpod 3.x).
///
/// Gerencia estado: lista de categorias, loading, erro, contagem de senhas.
class CategoriesNotifier extends Notifier<CategoriesState> {
  @override
  CategoriesState build() {
    return CategoriesState.initial();
  }

  /// Carrega todas as categorias com contagem de senhas.
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final service = ref.read(categoryServiceProvider);
      final categories = await service.getAllCategoriesWithCount();

      state = state.copyWith(
        isLoading: false,
        categories: categories,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar categorias',
      );
    }
  }

  /// Cria uma nova categoria e recarrega a lista.
  Future<void> createCategory({
    required String name,
    String? icon,
    int? color,
  }) async {
    try {
      final service = ref.read(categoryServiceProvider);
      await service.createCategory(name: name, icon: icon, color: color);
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao criar categoria',
      );
    }
  }

  /// Atualiza uma categoria existente e recarrega a lista.
  Future<void> updateCategory({
    required String id,
    required String name,
    String? icon,
    int? color,
  }) async {
    try {
      final service = ref.read(categoryServiceProvider);
      await service.updateCategory(id: id, name: name, icon: icon, color: color);
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao atualizar categoria',
      );
    }
  }

  /// Exclui uma categoria e recarrega a lista.
  Future<void> deleteCategory(String id) async {
    try {
      final service = ref.read(categoryServiceProvider);
      await service.deleteCategory(id);
      await loadCategories();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao excluir categoria',
      );
    }
  }
}
