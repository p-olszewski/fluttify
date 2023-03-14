class ShoppingList {
  String title;
  double sum;

  ShoppingList(this.title, this.sum);

  ShoppingList.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        sum = json['sum'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'sum': sum,
      };
}
