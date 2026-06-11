/// Entidade que representa uma categoria de organizacao de senhas.
///
/// Categorias pre-definidas no onboarding: Social, Email, Banco,
/// Compras, Trabalho, Outros. O usuario pode criar, editar e excluir.
class Category {
  /// Identificador unico (UUID v4).
  final String id;

  /// Nome da categoria (ex: "Social", "Banco").
  final String name;

  /// Identificador do icone (nullable — pode usar fallback).
  final String? icon;

  /// Cor em formato ARGB int (nullable — pode usar cor padrao).
  final int? color;

  /// Data/hora de criacao (ISO 8601).
  final DateTime createdAt;

  const Category({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.createdAt,
  });

  /// Cria uma copia com campos alterados.
  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
