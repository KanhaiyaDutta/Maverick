import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:maverick/views/login_view.dart';
// import 'package:maverick/views/notes/create_update_note_view.dart';
// import 'package:maverick/views/notes/notes_view.dart';
// import 'package:maverick/views/register_view.dart';
// import 'package:maverick/views/verify_email_view.dart';
// import 'package:maverick/services/auth/auth_service.dart';
// import 'package:maverick/constants/routes.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       home: const HomePage(),
//       routes: {
//         loginRoute: (context) => const LoginView(),
//         registerRoute: (context) => const RegisterView(),
//         notesRoute: (context) => const NotesView(),
//         verifyEmailRoute: (context) => const VerifyEmailView(),
//         createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
//       },
//     ),
//   );
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesView();
//               } else {
//                 return const VerifyEmailView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

void main() => runApp(const MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Testing Bloc'),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
            builder: (context, state) {
              final invalidValue =
                  (state is CounterStateInvalid) ? state.invalidValue : '';
              return Column(
                children: [
                  Text('Current Value => ${state.value}'),
                  Visibility(
                    visible: state is CounterStateInvalid,
                    child: Text('Invalid input: $invalidValue'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter a number here'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<CounterBloc>().add(
                                DecrementEvent(_controller.text),
                              );
                        },
                        child: const Text(
                          '-',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CounterBloc>().add(
                                IncrementEvent(_controller.text),
                              );
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
            listener: (context, state) => _controller.clear(),
          )),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(super.value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;
  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });

    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
            invalidValue: event.value, previousValue: state.value));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
