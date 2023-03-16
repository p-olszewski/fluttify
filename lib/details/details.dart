import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttify/services/firestore.dart';

class Details extends StatefulWidget {
  final String listId;
  final String listTitle;
  const Details({super.key, required this.listId, required this.listTitle});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  void initState() {
    super.initState();
    snapshot = getShoppingListDetails(widget.listId);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listTitle),
        centerTitle: true,
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                                // style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
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
