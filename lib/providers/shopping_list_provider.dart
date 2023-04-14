import 'package:flutter/material.dart';
import 'package:fluttify/services/firestore.dart';

class ShoppingListProvider with ChangeNotifier {
  String _listId = '';
  String _listTitle = '';
  double _totalPrice = 0.0;

  String get listId => _listId;
  String get listTitle => _listTitle;
  double get totalPrice => _totalPrice;

  void setListId(String listId) {
    _listId = listId;
    notifyListeners();
  }

  void setListTitle(String listTitle) {
    _listTitle = listTitle;
    notifyListeners();
  }

  void updateTotalPrice(String listId) async {
    _totalPrice = await countAndUpdateTotalPrice(listId);
    notifyListeners();
  }
}
