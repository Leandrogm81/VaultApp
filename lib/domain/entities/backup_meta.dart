/// Entidade que armazena metadados do ultimo backup realizado.
///
/// Usada para consultar estado antes de sobrepor arquivo na nuvem.
/// Nao entra no conteudo do backup.
class BackupMeta {
  /// Identificador do registro (singleton — sempre "main").
  final String id;

  /// Data/hora do ultimo backup (nullable — ainda nao fez backup).
  final DateTime? lastBackup;

  /// Hash do ultimo arquivo de backup (nullable — para verificacao de integridade).
  final String? fileHash;

  /// Caminho do arquivo na nuvem (nullable — Google Drive path).
  final String? cloudPath;

  const BackupMeta({
    required this.id,
    this.lastBackup,
    this.fileHash,
    this.cloudPath,
  });

  /// Cria uma copia com campos alterados.
  BackupMeta copyWith({
    String? id,
    DateTime? lastBackup,
    String? fileHash,
    String? cloudPath,
  }) {
    return BackupMeta(
      id: id ?? this.id,
      lastBackup: lastBackup ?? this.lastBackup,
      fileHash: fileHash ?? this.fileHash,
      cloudPath: cloudPath ?? this.cloudPath,
    );
  }
}
