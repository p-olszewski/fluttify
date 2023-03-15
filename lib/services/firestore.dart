import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttify/models/shopping_list.dart';

final FirebaseFirestore _database = FirebaseFirestore.instance;
final String? _uid = FirebaseAuth.instance.currentUser?.uid;

addList(ShoppingList newList) {
  _database.collection('shopping_lists').add(newList.toJson());
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingLists() {
  return _database.collection('shopping_lists').where('users', arrayContains: '$_uid').where('archived', isEqualTo: false).snapshots();
}

Future<String> getShoppingListTitle(String id) async {
  final doc = await FirebaseFirestore.instance.collection('shopping_lists').doc(id).get();
  return doc['title'];
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingListDetails(String id) {
  return _database.collection('shopping_lists').doc(id).collection('products').snapshots();
}
