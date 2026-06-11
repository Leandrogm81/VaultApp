import 'package:flutter_test/flutter_test.dart';
import 'package:vaultapp/domain/entities/backup_meta.dart';

void main() {
  group('BackupMeta', () {
    test('deve criar com id obrigatorio', () {
      final meta = BackupMeta(id: 'main');

      expect(meta.id, 'main');
      expect(meta.lastBackup, isNull);
      expect(meta.fileHash, isNull);
      expect(meta.cloudPath, isNull);
    });

    test('deve aceitar todos os campos opcionais', () {
      final now = DateTime(2026, 6, 10);
      final meta = BackupMeta(
        id: 'main',
        lastBackup: now,
        fileHash: 'abc123',
        cloudPath: '/backups/vault.enc',
      );

      expect(meta.lastBackup, now);
      expect(meta.fileHash, 'abc123');
      expect(meta.cloudPath, '/backups/vault.enc');
    });

    test('copyWith deve criar copia com campos alterados', () {
      final now = DateTime(2026, 6, 10);
      final original = BackupMeta(id: 'main');
      final copy = original.copyWith(
        lastBackup: now,
        fileHash: 'hash123',
      );

      expect(copy.id, 'main');
      expect(copy.lastBackup, now);
      expect(copy.fileHash, 'hash123');
      expect(copy.cloudPath, isNull);
    });
  });
}
