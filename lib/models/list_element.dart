class ListElement {
  String name;
  double price;
  bool bought;

  ListElement({required this.name, this.price = 0.0, this.bought = false});

  ListElement.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        bought = json['bought'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'bought': bought,
      };
}
