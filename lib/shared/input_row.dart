import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/services/firestore.dart';

class InputRow extends StatefulWidget {
  const InputRow({
    super.key,
    required this.listId,
  });

  final String listId;

  @override
  State<InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  String? _nameErrorText;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: nameInput(),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: priceInput(),
            ),
            const SizedBox(width: 10),
            addButton(context),
          ],
        ),
      ),
    );
  }

  Padding addButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ElevatedButton(
        onPressed: () {
          if (_nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nazwa produktu nie może być pusta!'),
                duration: Duration(seconds: 2),
              ),
            );
            setState(() => _nameErrorText = 'Pole wymagane');
          } else {
            final name = _nameController.text;
            final price = _priceController.text.isEmpty ? 0.00 : double.tryParse(_priceController.text);
            addListElement(ListElement(name: name, price: price!), widget.listId);
            _nameController.clear();
            _priceController.clear();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            setState(() => _nameErrorText = null);
          }
        },
        child: const Text("Dodaj"),
      ),
    );
  }

  TextField priceInput() {
    return TextField(
      controller: _priceController,
      decoration: const InputDecoration(
        labelText: 'Cena',
        border: UnderlineInputBorder(),
        hintText: "zł",
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
    );
  }

  Autocomplete<MapEntry<String, double>> nameInput() {
    return Autocomplete<MapEntry<String, double>>(
      displayStringForOption: (option) => option.key,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.length < 2) {
          return const Iterable<MapEntry<String, double>>.empty();
        }
        return findElement(textEditingValue.text.toUpperCase());
      },
      onSelected: (MapEntry<String, double> selection) {
        _nameController.text = selection.key.toString();
        _priceController.text = selection.value.toStringAsFixed(2);
      },
      fieldViewBuilder:
          (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        _nameController = textEditingController;
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Nazwa produktu *',
            border: const UnderlineInputBorder(),
            errorText: _nameErrorText,
          ),
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder:
          (BuildContext context, AutocompleteOnSelected<MapEntry<String, double>> onSelected, Iterable<MapEntry<String, double>> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 6.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: options.map((MapEntry<String, double> option) {
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 4.0, right: 30),
                      title: Text(option.key),
                      trailing: Text('${option.value.toStringAsFixed(2)} zł'),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
