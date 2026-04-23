import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/context_l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/post_auth_route.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/snackbars.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'auth_view_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (prev, next) {
      final error = next.error;
      if (error != null) Snackbars.showError(context, error);

      final user = next.valueOrNull;
      if (user != null) {
        scheduleRouterGo(context, resolvePostAuthDestination());
      }
    });

    final state = ref.watch(authViewModelProvider);
    final isLoading = state.isLoading;
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.registerTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            controller: _name,
                            label: l10n.nameLabel,
                            textInputAction: TextInputAction.next,
                            validator: (v) => Validators.requiredField(l10n, v),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(
                            controller: _email,
                            label: l10n.emailLabel,
                            hint: l10n.emailHint,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) => Validators.email(l10n, v),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppTextField(
                            controller: _password,
                            label: l10n.passwordLabel,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (v) => Validators.password(l10n, v),
                            enabled: !isLoading,
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppButton(
                            label: l10n.createAccountButton,
                            onPressed: isLoading ? null : _submit,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.go(AppRoutes.login);
                                      }
                                    },
                              child: Text(l10n.loginAction),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    await ref.read(authViewModelProvider.notifier).register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
        );
  }
}

