import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/services/firestore.dart';
import 'package:fluttify/shared/shared.dart';
import 'package:fluttify/shared/user_management_dialog.dart';

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
              builder: (context) => UserManagementDialog(listId: widget.listId),
            ),
            icon: const Icon(Icons.manage_accounts),
          ),
        ],
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            InputRow(listId: widget.listId),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: snapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ReorderableListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return ListElementCard(
                          key: ValueKey(doc.id),
                          listId: widget.listId,
                          doc: doc);
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      var doc = snapshot.data!.docs[oldIndex];
                      var listElement = ListElement(
                        name: doc['name'],
                        price: doc['price'],
                        bought: doc['bought'],
                      );
                      if (newIndex == snapshot.data!.docs.length - 1) {
                        listElement.order =
                            snapshot.data!.docs[newIndex]['order'] + 1;
                      } else if (newIndex == 0) {
                        listElement.order =
                            snapshot.data!.docs[newIndex]['order'] - 1;
                      } else if (oldIndex < newIndex) {
                        var lowerOrder = snapshot.data!.docs[newIndex]['order'];
                        var higherOrder =
                            snapshot.data!.docs[newIndex + 1]['order'];
                        listElement.order =
                            (higherOrder - lowerOrder) / 2 + lowerOrder;
                      } else if (newIndex < oldIndex) {
                        var lowerOrder =
                            snapshot.data!.docs[newIndex - 1]['order'];
                        var higherOrder =
                            snapshot.data!.docs[newIndex]['order'];
                        listElement.order =
                            (higherOrder - lowerOrder) / 2 + lowerOrder;
                      }
                      updateListElement(listElement, widget.listId, doc.id);
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
