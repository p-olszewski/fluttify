import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/services/firestore.dart';

class ListElementCard extends StatefulWidget {
  const ListElementCard({super.key, required this.doc, required this.listId});

  final QueryDocumentSnapshot<Object?> doc;
  final String listId;

  @override
  State<ListElementCard> createState() => _ListElementCardState();
}

class _ListElementCardState extends State<ListElementCard> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.doc['name'];
    priceController.text = widget.doc['price'].toString();
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
        deleteListElement(widget.listId, widget.doc.id);
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
          title: Row(
            children: [
              Checkbox(
                value: widget.doc['bought'],
                onChanged: (bool? value) {},
              ),
              Expanded(
                child: Text(widget.doc['name']),
              ),
              Text(
                '${widget.doc['price'].toStringAsFixed(2)} zł',
              ),
            ],
          ),
          onLongPress: () {
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
                    ),
                  ),
                  TextFormField(
                    controller: priceController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'Cena produktu',
                      hintText: "zł",
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ]),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Anuluj'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
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
