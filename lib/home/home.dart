import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/services/firestore.dart';

import '../shared/custom_textformfield.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  void initState() {
    super.initState();
    snapshot = getShoppingLists();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController _newListController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping lists'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.account_circle, size: 35),
          )
        ],
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
                          title: Text(doc['title']),
                          subtitle:
                              Text('Suma: ${doc['sum'].toStringAsFixed(2)} zł'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            if (!mounted) return;
                            Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: {
                                'id': doc.reference.id,
                                'title': doc['title'],
                              },
                            );
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Create shopping list'),
            contentPadding: const EdgeInsets.all(20.0),
            children: [
              CustomTextFormField(
                controller: _newListController,
                labelText: "Shopping list name",
                hintText: "my first list",
                obscure: false,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
        tooltip: 'Add',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
