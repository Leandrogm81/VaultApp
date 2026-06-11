import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/daos/password_dao.dart';
import '../../data/database/app_database.dart';

/// Servico de tags com operacoes de autocomplete e gerenciamento.
///
/// Gerencia tags: buscar existentes, validar limite, serializar/deserializar,
/// adicionar/remover tags de senhas.
class TagService {
  final PasswordDao _passwordDao;

  TagService(this._passwordDao);

  /// Busca todas as tags unicas existentes no vault.
  /// Retorna lista de strings unicas ordenada.
  Future<List<String>> getExistingTags() async {
    final tags = <String>{};
    final allPasswords = await _passwordDao.getAll();

    for (final row in allPasswords) {
      final passwordTags = deserializeTags(row.tags);
      tags.addAll(passwordTags);
    }

    return tags.toList()..sort();
  }

  /// Valida se a lista de tags respeita o limite de 10.
  /// Retorna true se valida, false se excede o limite.
  bool validateTagList(List<String> tags) {
    return tags.length <= 10;
  }

  /// Converte uma lista de tags para JSON array serializado.
  /// Exemplo: ['dev', 'work'] → '["dev","work"]'
  String serializeTags(List<String> tags) {
    return jsonEncode(tags);
  }

  /// Converte um JSON array serializado para lista de tags.
  /// Exemplo: '["dev","work"]' → ['dev', 'work']
  List<String> deserializeTags(String tagsJson) {
    if (tagsJson.isEmpty || tagsJson == '[]') return [];
    try {
      final decoded = jsonDecode(tagsJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  /// Adiciona uma tag a uma senha existente.
  /// Respeita o limite de 10 tags.
  Future<void> addTagToPassword(String passwordId, String tag) async {
    final password = await _passwordDao.getById(passwordId);
    if (password == null) throw Exception('Senha nao encontrada');

    final currentTags = deserializeTags(password.tags);
    if (currentTags.contains(tag)) return; // Tag ja existe
    if (currentTags.length >= 10) return; // Limite atingido

    currentTags.add(tag);
    final updatedJson = serializeTags(currentTags);

    await _updatePasswordTags(password, updatedJson);
  }

  /// Remove uma tag de uma senha existente.
  Future<void> removeTagFromPassword(String passwordId, String tag) async {
    final password = await _passwordDao.getById(passwordId);
    if (password == null) throw Exception('Senha nao encontrada');

    final currentTags = deserializeTags(password.tags);
    currentTags.remove(tag);
    final updatedJson = serializeTags(currentTags);

    await _updatePasswordTags(password, updatedJson);
  }

  /// Atualiza o campo tags de uma senha no banco.
  Future<void> _updatePasswordTags(
    PasswordsTableData password,
    String tagsJson,
  ) async {
    await _passwordDao.updatePassword(
      PasswordsTableCompanion(
        id: Value(password.id),
        title: Value(password.title),
        username: Value(password.username),
        password: Value(password.password),
        url: Value(password.url),
        notes: Value(password.notes),
        tags: Value(tagsJson),
        favorite: Value(password.favorite),
        categoryId: Value(password.categoryId),
        createdAt: Value(password.createdAt),
        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );
  }
}
