import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/providers/shopping_list_provider.dart';
import 'package:fluttify/services/firestore.dart';
import 'package:provider/provider.dart';

class ListElementCard extends StatefulWidget {
  const ListElementCard({super.key, required this.doc});

  final QueryDocumentSnapshot<Object?> doc;

  @override
  State<ListElementCard> createState() => _ListElementCardState();
}

class _ListElementCardState extends State<ListElementCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? _nameErrorText;
  String? _priceErrorText;
  late String listId;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.doc['name'];
    priceController.text = widget.doc['price'].toString();
    listId = context.read<ShoppingListProvider>().listId;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.doc.id),
      onDismissed: (direction) {
        context.read<ShoppingListProvider>().updateTotalPrice(listId);
        deleteListElement(listId, widget.doc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.doc['name']} usunięto z listy!'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      background: const Card(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          trailing: const Icon(Icons.drag_handle),
          contentPadding: const EdgeInsets.only(left: 0, right: 10),
          title: Row(
            children: [
              Checkbox(
                value: widget.doc['bought'],
                onChanged: (bool? value) {
                  updateListElement(
                    ListElement(
                      name: widget.doc['name'],
                      price: widget.doc['price'],
                      bought: value!,
                      order: widget.doc['order'],
                    ),
                    listId,
                    widget.doc.id,
                  );
                },
              ),
              Expanded(
                child: Text(widget.doc['name']),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.doc['price'].toStringAsFixed(2)} zł',
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Edytuj produkt'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    controller: nameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'Nazwa produktu',
                      hintText: 'np. Chleb',
                      errorText: _nameErrorText,
                    ),
                  ),
                  TextFormField(
                    controller: priceController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(labelText: 'Cena produktu', hintText: "zł", errorText: _priceErrorText),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ]),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Anuluj'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (nameController.text.isEmpty) {
                        setState(() => _nameErrorText = 'Pole wymagane');
                        return;
                      }
                      if (priceController.text.isEmpty) {
                        setState(() => _priceErrorText = 'Pole wymagane');
                        return;
                      }
                      try {
                        context.read<ShoppingListProvider>().updateTotalPrice(listId);
                        final name = nameController.text;
                        final price = priceController.text.isEmpty ? 0.00 : double.tryParse(priceController.text);
                        await updateListElement(
                            ListElement(
                              name: name,
                              price: price!,
                              order: widget.doc['order'],
                            ),
                            listId,
                            widget.doc.id);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Zaktualizowano produkt!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        setState(() => _nameErrorText = null);
                        setState(() => _priceErrorText = null);
                      } catch (e) {
                        // error handling
                      }
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: const Text('Zapisz'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
