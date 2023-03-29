import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/details/details.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/services/firestore.dart';

class InputRow extends StatelessWidget {
  const InputRow({
    super.key,
    required TextEditingController nameController,
    required TextEditingController priceController,
    required this.widget,
  })  : _nameController = nameController,
        _priceController = priceController;

  final TextEditingController _nameController;
  final TextEditingController _priceController;
  final Details widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  }
}
