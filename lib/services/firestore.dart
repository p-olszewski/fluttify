import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/models/shopping_list.dart';

final FirebaseFirestore _database = FirebaseFirestore.instance;
final String? _uid = FirebaseAuth.instance.currentUser?.uid;

addList(ShoppingList newList) {
  _database.collection('shopping_lists').add(newList.toJson());
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingLists() {
  return _database
      .collection('shopping_lists')
      .where('users', arrayContains: '$_uid')
      .snapshots();
}

getShoppingListDetails(String id) {
  _database
      .collection('shopping_lists')
      .doc(id)
      .collection('products')
      .get()
      .then((value) {
    Fluttertoast.showToast(msg: value.toString());
  });
}
