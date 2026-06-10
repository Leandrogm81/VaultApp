#!/bin/bash
# Script de testes do VaultApp
# Uso: ./scripts/test.sh [opções extras do flutter test]

set -e

# Garantir que flutter está no PATH
export PATH="/home/leandrogm81/flutter/bin:$PATH"

cd "$(dirname "$0")/.."

echo "=== VaultApp — Testes ==="
echo ""

# 1. Análise estática
echo "▶ flutter analyze"
flutter analyze
echo ""

# 2. Testes
echo "▶ flutter test"
flutter test "$@"
echo ""

echo "=== Todos os testes passaram! ==="
