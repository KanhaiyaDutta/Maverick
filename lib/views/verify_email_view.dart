import 'package:flutter/material.dart';
import 'package:maverick/constants/routes.dart';
import 'package:maverick/services/auth/auth_service.dart';

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
              "We've sent a verification email. Please click the link it.\n"),
          const Text(
              "Didn't recieve the email yet, press the button below to resend"),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Send verification link')),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
