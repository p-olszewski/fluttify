import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Fluttertoast.showToast(msg: 'This email address is not registered.');
    } else if (e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Wrong password.');
    }
    return false;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    return false;
  }
}
