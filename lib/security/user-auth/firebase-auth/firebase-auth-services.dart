
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseAuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      await userCredential.user!.updateDisplayName(username);
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getFutureCurrentUser(){
    return Future.value(_firebaseAuth.currentUser);
  }
}
