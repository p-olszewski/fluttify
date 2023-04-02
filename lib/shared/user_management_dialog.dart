import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/services/firestore.dart';

class UserManagementDialog extends StatefulWidget {
  const UserManagementDialog({
    super.key,
    required this.listId,
  });

  final String listId;

  @override
  State<UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<UserManagementDialog> {
  final TextEditingController _emailController = TextEditingController();
  late Future<dynamic> userEmails;

  @override
  void initState() {
    super.initState();
    userEmails = getShoppingListUserEmails(widget.listId);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zarządzaj użytkownikami'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: userEmails,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return SizedBox(
                height: 150,
                width: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Chip(
                      label: Text(snapshot.data![index]),
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
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              autofocus: true,
              controller: _emailController,
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          child: const Text('Udostępnij'),
          onPressed: () {
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
