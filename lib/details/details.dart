import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/models/list_element.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    snapshot = getShoppingListDetails(widget.listId);
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

    var inputRow = Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nazwa produktu *'),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Cena', hintText: "zł"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 40,
            width: 80,
            child: ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final price = _priceController.text.isEmpty ? 0.00 : double.tryParse(_priceController.text);
                addListElement(ListElement(name: name, price: price!), widget.listId);
                _nameController.clear();
                _priceController.clear();
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: const Text("Dodaj"),
            ),
          ),
        ],
      ),
    );

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
            inputRow,
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
