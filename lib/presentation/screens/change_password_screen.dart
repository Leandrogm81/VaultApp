import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/change_password_viewmodel.dart';

/// Tela de alteracao de senha mestra.
///
/// Formulario com 3 campos: senha atual, nova senha, confirmacao.
/// Segue /docs/design/UI_UX_GUIDE.md.
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(changePasswordProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar senha mestra'),
      ),
      body: state.isSuccess
          ? _buildSuccessView(context, colorScheme)
          : _buildFormView(context, state, colorScheme),
    );
  }

  Widget _buildSuccessView(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Senha alterada com sucesso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Backups antigos feitos com a senha anterior nao poderao ser restaurados com a nova senha.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context,
    ChangePasswordState state,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Descricao
          Text(
            'Para alterar sua senha mestra, primeiro valide a senha atual e defina uma nova senha.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),

          // Campo: Senha atual
          TextField(
            obscureText: _obscureCurrent,
            onChanged: (value) {
              ref
                  .read(changePasswordProvider.notifier)
                  .updateCurrentPassword(value);
            },
            decoration: InputDecoration(
              labelText: 'Senha atual',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: Nova senha
          TextField(
            obscureText: _obscureNew,
            onChanged: (value) {
              ref
                  .read(changePasswordProvider.notifier)
                  .updateNewPassword(value);
            },
            decoration: InputDecoration(
              labelText: 'Nova senha',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              helperText: 'Minimo 8 caracteres',
              helperStyle: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() => _obscureNew = !_obscureNew);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Campo: Confirmacao
          TextField(
            obscureText: _obscureConfirm,
            onChanged: (value) {
              ref
                  .read(changePasswordProvider.notifier)
                  .updateConfirmPassword(value);
            },
            decoration: InputDecoration(
              labelText: 'Confirmar nova senha',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Mensagem de erro
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.error,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Botao: Alterar Senha
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () {
                      ref
                          .read(changePasswordProvider.notifier)
                          .changePassword();
                    },
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Alterar senha'),
            ),
          ),
        ],
      ),
    );
  }
}
