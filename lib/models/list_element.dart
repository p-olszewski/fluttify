import 'package:cloud_firestore/cloud_firestore.dart';

class ListElement {
  String name;
  double price;
  bool bought;
  FieldValue? timestamp;
  double order;

  ListElement(
      {required this.name,
      this.price = 0.0,
      this.bought = false,
      this.timestamp,
      this.order = 0});

  ListElement.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        bought = json['bought'],
        timestamp = json['timestamp'],
        order = json['order'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'bought': bought,
        'timestamp': FieldValue.serverTimestamp(),
        'order': order,
      };
}
