import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/models/shopping_list.dart';
import 'package:fluttify/providers/shopping_list_provider.dart';
import 'package:fluttify/services/auth.dart';
import 'package:fluttify/services/firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;
  final TextEditingController _newListController = TextEditingController();

  @override
  void initState() {
    super.initState();
    snapshot = getShoppingLists();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
                          subtitle: Text('Suma: ${doc['sum'].toStringAsFixed(2)} zł'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            if (!mounted) return;
                            context.read<ShoppingListProvider>().setListId(doc.reference.id);
                            context.read<ShoppingListProvider>().setListTitle(doc['title']);
                            context.read<ShoppingListProvider>().updateTotalPrice(doc.reference.id);
                            Navigator.pushNamed(context, '/details');
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Czy chcesz usunąć listę?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      deleteShoppingList(doc.reference.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Tak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Nie'),
                                  )
                                ],
                              ),
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
            builder: (context) => AlertDialog(
                  title: const Text('Podaj nazwę listy'),
                  content: TextField(
                    controller: _newListController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Nazwa listy', hintText: 'np. Biedronka'),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Zapisz'),
                      onPressed: () {
                        var userId = getUserId();
                        if (userId != null) {
                          var title = _newListController.text;
                          addShoppingList(ShoppingList(title, users: [userId]));
                          Fluttertoast.showToast(
                            msg: 'Lista $title została dodana',
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Nie jesteś zalogowany, musisz się zalogować',
                          );
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )),
        tooltip: 'Add',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
