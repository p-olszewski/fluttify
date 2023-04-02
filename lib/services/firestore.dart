import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttify/models/list_element.dart';
import 'package:fluttify/models/shopping_list.dart';

final FirebaseFirestore _database = FirebaseFirestore.instance;
final String? _uid = FirebaseAuth.instance.currentUser?.uid;

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingLists() {
  return _database.collection('shopping_lists').where('users', arrayContains: '$_uid').where('archived', isEqualTo: false).snapshots();
}

addShoppingList(ShoppingList newList) {
  _database.collection('shopping_lists').add(newList.toJson());
}

deleteShoppingList(String listId) {
  _database.collection('shopping_lists').doc(listId).collection('products').get().then(
    (QuerySnapshot<Map<String, dynamic>> value) {
      for (var element in value.docs) {
        _database.collection('shopping_lists').doc(listId).collection('products').doc(element.id).delete();
      }
      _database.collection('shopping_lists').doc(listId).delete();
    },
  );
}

Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingListElements(String listId) {
  return _database.collection('shopping_lists/$listId/products').orderBy('timestamp').snapshots();
}

addListElement(ListElement newElement, String listId) {
  _database.collection('/shopping_lists/$listId/products').add(newElement.toJson());
  updateSumPrice(listId);
}

deleteListElement(String listId, String elementId) {
  _database.doc('/shopping_lists/$listId/products/$elementId').delete();
  updateSumPrice(listId);
}

updateSumPrice(String listId) async {
  final listRef = _database.doc('shopping_lists/$listId');
  final productsSnapshot = await listRef.collection('products').get();
  double sum = 0;

  for (var element in productsSnapshot.docs) {
    final price = element.data()['price'] ?? 0;
    sum += price;
  }

  await listRef.update({
    'sum': sum,
  });
}

Future<dynamic> getShoppingListUserEmails(String listId) async {
  final shoppingListSnapshot = await _database.doc('shopping_lists/$listId').get();
  final userIds = List.from((shoppingListSnapshot.data())?['users']);
  final userEmails = await Future.wait(
    userIds.map((userId) async => (await _database.doc('users/$userId').get()).data()!['email']),
  );

  return userEmails.where((email) => email != null).cast<String>().toList();
}

addUserToShoppingList(String listId, String userEmail) async {
  final userSnapshot = await _database.collection('users').where('email', isEqualTo: userEmail).get();
  if (userSnapshot.docs.isEmpty) {
    throw 'Nie znaleziono użytkownika $userEmail.';
  }
  final shoppingListSnapshot = await _database.doc('shopping_lists/$listId').get();
  final userIds = List.from((shoppingListSnapshot.data())?['users']);
  if (userIds.contains(userSnapshot.docs.first.id)) {
    throw 'Użytkownik jest już dodany do tej listy.';
  }
  _database.doc('shopping_lists/$listId').update({
    'users': FieldValue.arrayUnion([userSnapshot.docs.first.id]),
  });
}

deleteUserFromShoppingList(String listId, String userEmail) async {
  final userSnapshot = await _database.collection('users').where('email', isEqualTo: userEmail).get();
  if (userSnapshot.docs.isEmpty) {
    throw 'Nie znaleziono użytkownika $userEmail.';
  }
  final userId = userSnapshot.docs.first.id;
  _database.doc('shopping_lists/$listId').update({
    'users': FieldValue.arrayRemove([userId]),
  });
}
