import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maverick/constants/routes.dart';
import 'package:maverick/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
              controller: _email,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: ' Enter your email')),
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
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-email') {
                    await showErrorDialog(context, 'Invalid email address');
                  } else if (e.code == 'weak-password') {
                    await showErrorDialog(context, 'Weak Password');
                  } else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(context, 'Email is already in use');
                  } else
                    await showErrorDialog(context, 'Error: ${e.code}');
                } catch (e) {
                  showErrorDialog(context, e.toString());
                }
              },
              child: const Text('Sign up')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already registered? Log in'))
        ],
      ),
    );
  }
}
