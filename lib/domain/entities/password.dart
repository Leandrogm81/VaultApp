/// Entidade que representa uma credencial armazenada no vault.
///
/// Campos `password` e `notes` serao criptografados com AES-256-GCM
/// (Sprint 4). Demais campos ficam em texto claro para busca e exibicao.
class Password {
  /// Identificador unico (UUID v4).
  final String id;

  /// ID da categoria vinculada (nullable — pode nao ter categoria).
  final String? categoryId;

  /// Titulo da credencial (ex: "GitHub", "Gmail").
  final String title;

  /// Nome de usuario ou email (texto claro, permite busca).
  final String username;

  /// Senha criptografada (texto claro apenas em memoria durante uso).
  final String password;

  /// URL do servico (nullable).
  final String? url;

  /// Observacoes livres (criptografadas, nullable).
  final String? notes;

  /// Tags de organizacao (JSON array, maximo 10).
  final List<String> tags;

  /// Se a credencial esta nos favoritos.
  final bool favorite;

  /// Data/hora de criacao (ISO 8601).
  final DateTime createdAt;

  /// Data/hora da ultima atualizacao (ISO 8601).
  final DateTime updatedAt;

  const Password({
    required this.id,
    this.categoryId,
    required this.title,
    required this.username,
    required this.password,
    this.url,
    this.notes,
    this.tags = const [],
    this.favorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma copia com campos alterados.
  Password copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    List<String>? tags,
    bool? favorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Password(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
