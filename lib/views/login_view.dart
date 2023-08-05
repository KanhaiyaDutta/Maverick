import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maverick/services/auth/auth_exceptions.dart';
import 'package:maverick/services/auth/bloc/auth_bloc.dart';
import 'package:maverick/services/auth/bloc/auth_events.dart';
import 'package:maverick/services/auth/bloc/auth_state.dart';
import 'package:maverick/utilities/dialogs/loading_dart.dart';

import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialoghandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialoghandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialoghandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialoghandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Log in')),
        body: Column(
          children: [
            TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: ' Enter your email')),
            TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: ' Enter your password 🤫')),
            OutlinedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogIn(
                      email,
                      password,
                    ));
              },
              child: const Text('Sign in'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text('Not Registered yet? Register here'))
          ],
        ),
      ),
    );
  }
}
