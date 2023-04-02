import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _nameErrorText;

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
                        deleteUserFromShoppingList(widget.listId, snapshot.data![index]);
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(msg: 'Usunięto ${snapshot.data![index]} z listy.');
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
              decoration: InputDecoration(
                labelText: 'Email nowego użytkownika',
                hintText: 'np. test@test.com',
                errorText: _nameErrorText,
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
          onPressed: () async {
            if (_emailController.text.isEmpty) {
              setState(() => _nameErrorText = 'Pole wymagane');
              return;
            }
            addUserToShoppingList(widget.listId, _emailController.text).then((value) {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              setState(() => _nameErrorText = null);
              if (!mounted) return;
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: 'Udostępniono listę dla ${_emailController.text}');
              _emailController.clear();
            }).catchError((error) {
              setState(() => _nameErrorText = error.toString());
            });
          },
        ),
      ],
    );
  }
}
