import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maverick/services/auth/auth_service.dart';
import 'package:maverick/services/auth/bloc/auth_bloc.dart';
import 'package:maverick/services/auth/bloc/auth_events.dart';
import 'package:maverick/services/cloud/cloud_note.dart';
import 'package:maverick/services/cloud/firebase_cloud_storage.dart';
import 'package:maverick/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: Container(
          color: const Color(0xFF0C1C2E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  PopupMenuButton<MenuAction>(
                    iconColor: Colors.white,
                    onSelected: (value) async {
                      switch (value) {
                        case MenuAction.logout:
                          final shouldLogOut = await showLogOutDialog(context);
                          if (shouldLogOut) {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          }
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem<MenuAction>(
                          value: MenuAction.logout,
                          child: Text('Log out'),
                        )
                      ];
                    },
                  )
                ],
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Your Notes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentID);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
