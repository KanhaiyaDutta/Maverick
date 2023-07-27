import 'package:flutter/material.dart';
import 'package:maverick/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty note',
    optionsBuilder: () => {'OK': null},
  );
}
