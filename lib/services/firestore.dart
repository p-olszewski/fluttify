import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttify/models/shopping_list.dart';
import 'package:fluttify/models/list_element.dart';

final FirebaseFirestore _database = FirebaseFirestore.instance;
final String? _uid = FirebaseAuth.instance.currentUser?.uid;

addList(ShoppingList newList) {
  _database.collection('shopping_lists').add(newList.toJson());
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingLists() {
  return _database.collection('shopping_lists').where('users', arrayContains: '$_uid').where('archived', isEqualTo: false).snapshots();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingListDetails(String id) {
  return _database.collection('shopping_lists').doc(id).collection('products').snapshots();
}

addListElement(ListElement newElement, String listId) {
  _database.collection('/shopping_lists/$listId/products').add(newElement.toJson());
}
