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
  return _database.collection('shopping_lists/$listId/products').orderBy('order').snapshots();
}

addListElement(ListElement newElement, String listId) {
  _database.collection('/shopping_lists/$listId/products').add(newElement.toJson());
}

Future<double> getMaxOrder(String listId) async {
  var doc = await _database.collection('/shopping_lists/$listId/products').orderBy('order', descending: true).limit(1).get();
  return doc.docs.isNotEmpty ? doc.docs.first['order'] + 1 : 0;
}

deleteListElement(String listId, String elementId) {
  _database.doc('/shopping_lists/$listId/products/$elementId').delete();
}

updateListElement(ListElement updatedElement, String listId, String elementId) {
  _database.doc('/shopping_lists/$listId/products/$elementId').update(updatedElement.toJson());
}

Future<double> countAndUpdateTotalPrice(String listId) async {
  final listRef = _database.doc('shopping_lists/$listId');
  final productsSnapshot = await listRef.collection('products').get();
  double sum = 0;
  for (var element in productsSnapshot.docs) {
    final price = element.data()['price'] ?? 0;
    sum += price;
  }
  sum = double.parse(sum.toStringAsFixed(2));

  await listRef.update({'sum': sum});
  return sum;
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

Future<bool> addUserDocument(String uid, String email) async {
  if (uid.isEmpty || email.isEmpty) {
    return false;
  }
  try {
    await _database.doc('users/$uid').set({
      'email': email,
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<MapEntry<String, double>>> findElement(String text) async {
  final productsSnapshot = await _database
      .collection('products')
      .where('name', isGreaterThanOrEqualTo: text)
      .where('name', isLessThanOrEqualTo: '$text\uf8ff')
      .limit(3)
      .get();

  return productsSnapshot.docs.map<MapEntry<String, double>>((doc) => MapEntry(doc.data()['name'], doc.data()['price'])).toList();
}
