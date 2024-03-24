import 'package:flutter/material.dart';
import 'package:maverick/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Stack(
          children: [
            Card(
              color: Color.fromARGB(255, 220, 215, 215),
              child: ListTile(
                shape: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.black54,
                  width: 0.7,
                )),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 20,
                ),
                onTap: () {
                  onTap(note);
                },
                title: Text(
                  note.text,
                  maxLines: 5,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    );
  }
}

//  itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes.elementAt(index);
//           return ListTile(
//             onTap: () {
//               onTap(note);
//             },
//             title: Text(
//                note.text,
//               maxLines: 1,
//               softWrap: true,
//               overflow: TextOverflow.ellipsis,
//             ),
//             trailing: IconButton(
//               onPressed: () async {
//                 final shouldDelete = await showDeleteDialog(context);
//                 if (shouldDelete) {
//                   onDeleteNote(note);
//                 }
//               },
//               icon: const Icon(Icons.delete),
//             ),
//           );
//         }