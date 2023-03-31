import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/models/shopping_list.dart';

final FirebaseFirestore _database = FirebaseFirestore.instance;
final String? _uid = FirebaseAuth.instance.currentUser?.uid;

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingLists() {
  return _database
      .collection('shopping_lists')
      .where('users', arrayContains: '$_uid')
      .where('archived', isEqualTo: false)
      .snapshots();
}

addList(ShoppingList newList) {
  _database.collection('shopping_lists').add(newList.toJson());
}

deleteList(String listId) {
  _database
      .collection('shopping_lists')
      .doc(listId)
      .collection('products')
      .get()
      .then(
    (QuerySnapshot<Map<String, dynamic>> value) {
      for (var element in value.docs) {
        _database
            .collection('shopping_lists')
            .doc(listId)
            .collection('products')
            .doc(element.id)
            .delete();
      }
      _database.collection('shopping_lists').doc(listId).delete();
    },
  );
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingListDetails(String id) {
  return _database
      .collection('shopping_lists')
      .doc(id)
      .collection('products')
      .snapshots();
}

addListElement(ListElement newElement, String listId) {
  _database
      .collection('/shopping_lists/$listId/products')
      .add(newElement.toJson());
}
