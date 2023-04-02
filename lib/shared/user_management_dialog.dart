import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserManagementDialog extends StatefulWidget {
  const UserManagementDialog({
    super.key,
    required TextEditingController addUserController,
  }) : _addUserController = addUserController;

  final TextEditingController _addUserController;

  @override
  State<UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<UserManagementDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zarządzaj użytkownikami'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: const Text('tomasz.baltonowski@test.com'),
            labelStyle: const TextStyle(fontSize: 12),
            onDeleted: () {
              Fluttertoast.showToast(
                msg: 'Usunięto użytkownika z listy',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0,
              );
            },
          ),
          Chip(
            label: const Text('krzysztof.kolumb@test.com'),
            labelStyle: const TextStyle(fontSize: 12),
            onDeleted: () {
              Fluttertoast.showToast(
                msg: 'Usunięto użytkownika z listy',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                fontSize: 16.0,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: widget._addUserController,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                labelText: 'Email nowego użytkownika',
                hintText: 'np. test@test.com',
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Udostępnij'),
          onPressed: () {
            widget._addUserController.clear();
            Fluttertoast.showToast(
              msg: 'Udostępniono listę',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
            );
          },
        ),
      ],
    );
  }
}
