import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/details/details.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/services/firestore.dart';

class InputRow extends StatefulWidget {
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
  State<InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  String? _nameErrorText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: TextField(
                controller: widget._nameController,
                decoration: InputDecoration(
                  labelText: 'Nazwa produktu *',
                  border: const OutlineInputBorder(),
                  errorText: _nameErrorText,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 1,
              child: TextField(
                controller: widget._priceController,
                decoration: const InputDecoration(
                  labelText: 'Cena',
                  border: OutlineInputBorder(),
                  hintText: "zł",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 58,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (widget._nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nazwa produktu nie może być pusta!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() => _nameErrorText = 'Pole wymagane');
                  } else {
                    final name = widget._nameController.text;
                    final price = widget._priceController.text.isEmpty ? 0.00 : double.tryParse(widget._priceController.text);
                    addListElement(ListElement(name: name, price: price!), widget.widget.listId);
                    widget._nameController.clear();
                    widget._priceController.clear();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    setState(() => _nameErrorText = null);
                  }
                },
                child: const Text("Dodaj"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
