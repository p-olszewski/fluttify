import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListElementCard extends StatelessWidget {
  const ListElementCard({
    super.key,
    required this.doc,
  });

  final QueryDocumentSnapshot<Object?> doc;

  @override
  Widget build(BuildContext context) {
    return Card(
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
      ),
    );
  }
}
