class ShoppingList {
  String title;
  double sum;
  bool archived;
  List<String> users;

  ShoppingList(this.title,
      {this.sum = 0, this.archived = false, this.users = const []});

  ShoppingList.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        sum = json['sum'],
        archived = json['archived'],
        users = json['users'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'sum': sum,
        'archived': archived,
        'users': users,
      };
}
