import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../viewmodels/password_form_viewmodel.dart';
import '../../domain/entities/password.dart';

/// Tela de formulario para adicionar ou editar senha.
///
/// Segue UI/UX Guide: labels, validacao visual, estados.
class PasswordFormScreen extends ConsumerStatefulWidget {
  /// ID da senha para edicao (null para criacao).
  final String? passwordId;

  /// Senha existente para preencher o formulario (null para criacao).
  final Password? existingPassword;

  const PasswordFormScreen({
    super.key,
    this.passwordId,
    this.existingPassword,
  });

  @override
  ConsumerState<PasswordFormScreen> createState() => _PasswordFormScreenState();
}

class _PasswordFormScreenState extends ConsumerState<PasswordFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _urlController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _urlController = TextEditingController();
    _notesController = TextEditingController();

    // Inicializa o ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(passwordFormProvider.notifier);
      if (widget.existingPassword != null) {
        notifier.initializeForEdit(widget.existingPassword!);
        _titleController.text = widget.existingPassword!.title;
        _usernameController.text = widget.existingPassword!.username;
        _passwordController.text = widget.existingPassword!.password;
        _urlController.text = widget.existingPassword!.url ?? '';
        _notesController.text = widget.existingPassword!.notes ?? '';
      } else {
        notifier.initializeForCreate();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final formState = ref.watch(passwordFormProvider);

    // Observa submitSuccess para navegar
    ref.listen<PasswordFormState>(passwordFormProvider, (prev, next) {
      if (next.submitSuccess) {
        context.pop(true); // retorna true para recarregar
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          formState.isEditing ? 'Editar Senha' : 'Adicionar Senha',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo Titulo (obrigatorio)
            _buildTextField(
              controller: _titleController,
              label: 'Titulo *',
              hint: 'Ex: GitHub, Gmail',
              errorText: formState.errors['title'],
              onChanged: (value) {
                ref.read(passwordFormProvider.notifier).updateField('title', value);
              },
            ),
            const SizedBox(height: 16),

            // Campo Username
            _buildTextField(
              controller: _usernameController,
              label: 'Usuario',
              hint: 'email@exemplo.com',
              onChanged: (value) {
                ref.read(passwordFormProvider.notifier).updateField('username', value);
              },
            ),
            const SizedBox(height: 16),

            // Campo Senha (obrigatorio)
            _buildTextField(
              controller: _passwordController,
              label: 'Senha *',
              hint: 'Digite a senha',
              obscureText: true,
              errorText: formState.errors['password'],
              onChanged: (value) {
                ref.read(passwordFormProvider.notifier).updateField('password', value);
              },
            ),
            const SizedBox(height: 16),

            // Campo URL
            _buildTextField(
              controller: _urlController,
              label: 'URL',
              hint: 'https://exemplo.com',
              keyboardType: TextInputType.url,
              onChanged: (value) {
                ref.read(passwordFormProvider.notifier).updateField('url', value);
              },
            ),
            const SizedBox(height: 16),

            // Campo Notas (multiline)
            _buildTextField(
              controller: _notesController,
              label: 'Notas',
              hint: 'Observacoes opcionais',
              maxLines: 3,
              onChanged: (value) {
                ref.read(passwordFormProvider.notifier).updateField('notes', value);
              },
            ),
            const SizedBox(height: 16),

            // Toggle Favorito
            SwitchListTile(
              title: const Text('Favorito'),
              subtitle: const Text('Adicionar aos favoritos'),
              value: formState.isFavorite,
              onChanged: (_) {
                ref.read(passwordFormProvider.notifier).toggleFavorite();
              },
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Mensagem de erro geral
            if (formState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  formState.errorMessage!,
                  style: TextStyle(
                    color: colorScheme.error,
                    fontSize: 13,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Botoes
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: formState.isSubmitting
                        ? null
                        : () {
                            context.pop(false);
                          },
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: formState.isSubmitting
                        ? null
                        : () {
                            ref.read(passwordFormProvider.notifier).submit();
                          },
                    child: formState.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Constroi um campo de texto padrao.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
    );
  }
}
