import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maverick/services/auth/bloc/auth_bloc.dart';
import 'package:maverick/services/auth/bloc/auth_events.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent a verification email. Please click the link in it.\n"),
          const Text(
              "Didn't recieve the email yet, press the button below to resend"),
          TextButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text('Send verification link')),
          TextButton(
            onPressed: () async {
              context
                    .read<AuthBloc>()
                    .add(const AuthEventLogOut());
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
