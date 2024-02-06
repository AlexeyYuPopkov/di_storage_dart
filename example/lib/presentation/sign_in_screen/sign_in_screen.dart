import 'package:example/presentation/common_widgets/blocking_loading_indicator.dart';
import 'package:example/presentation/common_widgets/dialog_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/sign_in_screen_bloc.dart';
import 'bloc/sign_in_screen_event.dart';
import 'bloc/sign_in_screen_state.dart';

final class SignInScreenRouteToHome {
  const SignInScreenRouteToHome();
}

final class SignInScreen extends StatelessWidget with DialogHelper {
  final Future Function(BuildContext, Object) onRoute;

  const SignInScreen({super.key, required this.onRoute});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) => SignInScreenBloc(),
        child: BlocConsumer<SignInScreenBloc, SignInScreenState>(
          listener: _listener,
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: _SignInForm(
                  onLogin: (login, password) => _tryLogin(
                    context,
                    login: login,
                    password: password,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _listener(BuildContext context, SignInScreenState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
    switch (state) {
      case CommonState():
      case LoadingState():
        break;
      case ErrorState():
        showMessage(
          context,
          parameters: DialogHelperData(
            title: context.errorDialogTitle,
            message: context.unknownErrorMessage,
          ),
        );
        break;
      case ShouldLoginState():
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> _tryLogin(
    BuildContext context, {
    required String login,
    required String password,
  }) async {
    context.read<SignInScreenBloc>().add(
          SignInScreenEvent.trySignIn(login: login, password: password),
        );
  }
}

// Sign in form
final class _SignInForm extends StatefulWidget {
  final void Function(String login, String password) onLogin;

  const _SignInForm({required this.onLogin});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  late final formKey = GlobalKey<FormState>();
  late final loginKey = GlobalKey<FormFieldState>();
  late final passwordKey = GlobalKey<FormFieldState>();
  late final loginController = TextEditingController();
  late final passwordController = TextEditingController();
  late final loginFocusNode = FocusNode();
  late final passwordFocusNode = FocusNode();

  bool isValidForm = false;

  @override
  void initState() {
    _setupSubscriptions();
    super.initState();
  }

  void _setupSubscriptions() {
    loginFocusNode.addListener(() {
      if (!loginFocusNode.hasFocus) {
        loginKey.currentState?.validate();
      }
    });
    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        passwordKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    loginFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: formKey,
        onChanged: () {
          final isValid = _checkIfFormValid();
          if (isValidForm != isValid) {
            setState(() => isValidForm = isValid);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24.0),
            Text(
              context.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              key: loginKey,
              controller: loginController,
              focusNode: loginFocusNode,
              decoration: InputDecoration(
                labelText: context.loginLabel,
              ),
              validator: _notEmptyValidator,
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              key: passwordKey,
              controller: passwordController,
              focusNode: passwordFocusNode,
              decoration: InputDecoration(
                labelText: context.passwordLabel,
              ),
              validator: _notEmptyValidator,
            ),
            const SizedBox(height: 48.0),
            OutlinedButton(
              onPressed: isValidForm ? () => _onSignIn(context) : null,
              child: Text(
                context.signInButtonTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _notEmptyValidator(String? str) =>
      str == null || str.isEmpty ? context.validationErrorNotEmpty : null;

  bool _checkIfFormValid() => [
        _notEmptyValidator(loginController.text),
        _notEmptyValidator(passwordController.text),
      ].where((e) => e != null).isEmpty;

  void _onSignIn(BuildContext context) {
    if (formKey.currentState?.validate() == true) {
      if (isValidForm) {
        formKey.currentState?.save();

        widget.onLogin(
          loginController.text,
          passwordController.text,
        );
      }
    }
  }
}

extension on BuildContext {
  String get title => 'Sign In';
  String get description => 'Input any strings to login and password fields';
  String get loginLabel => 'Login';
  String get passwordLabel => 'Password';
  String get signInButtonTitle => 'Sign In';

  String get validationErrorNotEmpty => 'This field is required';
  String get errorDialogTitle => 'Error';
  String get unknownErrorMessage => 'Something went wrong';
}
