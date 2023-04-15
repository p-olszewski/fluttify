import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/providers/shopping_list_provider.dart';
import 'package:fluttify/services/firestore.dart';
import 'package:fluttify/widgets/custom_appbar.dart';
import 'package:fluttify/widgets/input_row.dart';
import 'package:fluttify/widgets/list_element_card.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late String listId;
  late String listTitle;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    listId = context.read<ShoppingListProvider>().listId;
    listTitle = context.read<ShoppingListProvider>().listTitle;
    snapshot = getShoppingListElements(listId);
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
    totalPrice = context.watch<ShoppingListProvider>().totalPrice;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            const InputRow(),
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
                      return ListElementCard(key: ValueKey(doc.id), doc: doc);
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
                        listElement.order = snapshot.data!.docs[newIndex]['order'] + 1;
                      } else if (newIndex == 0) {
                        listElement.order = snapshot.data!.docs[newIndex]['order'] - 1;
                      } else if (oldIndex < newIndex) {
                        var lowerOrder = snapshot.data!.docs[newIndex]['order'];
                        var higherOrder = snapshot.data!.docs[newIndex + 1]['order'];
                        listElement.order = (higherOrder - lowerOrder) / 2 + lowerOrder;
                      } else if (newIndex < oldIndex) {
                        var lowerOrder = snapshot.data!.docs[newIndex - 1]['order'];
                        var higherOrder = snapshot.data!.docs[newIndex]['order'];
                        listElement.order = (higherOrder - lowerOrder) / 2 + lowerOrder;
                      }
                      updateListElement(listElement, listId, doc.id);
                      context.read<ShoppingListProvider>().updateTotalPrice(listId);
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
