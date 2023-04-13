import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/services/firestore.dart';

class ListElementCard extends StatelessWidget {
  const ListElementCard({super.key, required this.doc, required this.listId});

  final QueryDocumentSnapshot<Object?> doc;
  final String listId;
  // final TextEditingController nameController;
  // final TextEditingController priceController;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(doc.id),
      onDismissed: (direction) {
        deleteListElement(listId, doc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${doc['name']} usunięto z listy!'),
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
                value: doc['bought'],
                onChanged: (bool? value) {},
              ),
              Expanded(
                child: Text(doc['name']),
              ),
              Text(
                '${doc['price'].toStringAsFixed(2)} zł',
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
                    // controller: nameController,
                    initialValue: doc['name'],
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: 'Nazwa produktu',
                      hintText: 'np. Chleb',
                    ),
                  ),
                  TextFormField(
                    // controller: priceController,
                    initialValue: doc['price'].toString(),
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
