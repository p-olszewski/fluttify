import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/services/firestore.dart';
import 'package:fluttify/shared/shared.dart';

class Details extends StatefulWidget {
  final String listId;
  final String listTitle;
  const Details({super.key, required this.listId, required this.listTitle});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addUserController = TextEditingController();

  @override
  void initState() {
    super.initState();
    snapshot = getShoppingListElements(widget.listId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Zarządzaj użytkownikami'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: const Text('tomasz.baltonowski@test.com'),
                            backgroundColor: Colors.green,
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
                            backgroundColor: Colors.blue,
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
                            padding: const EdgeInsets.only(top: 30),
                            child: TextField(
                              controller: _addUserController,
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
                            _addUserController.clear();
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
                    )),
            icon: const Icon(Icons.manage_accounts),
          ),
        ],
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            InputRow(
              nameController: _nameController,
              priceController: _priceController,
              widget: widget,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: snapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return ListElementCard(listId: widget.listId, doc: doc);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
