import 'package:authentication_x/authentication_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopify/constants.dart';
import 'package:models/User.dart' as U;

class FirebaseAuthDatasource extends AuthDataSource {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<String> signup(String username, String email, String password) async {
    var signup = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await signup.user!.updateProfile(displayName: username);
    return Future.value(signup.user!.uid);
  }

  @override
  Future<void> createUserInDatabase(U.User user) {
    return _firestore
        .collection(USERS_COLLECTION)
        .doc(user.id)
        .set(user.toDocument());
  }

  @override
  Future<void> updateUserData(U.User user) {
    return _firestore
        .collection(USERS_COLLECTION)
        .doc(user.id)
        .update(user.toDocument());
  }

  Future deleteUser() async {
    await _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .delete();
    return _auth.currentUser!.delete();
  }

  Stream<U.User> get userData => _firestore
      .collection(USERS_COLLECTION)
      .doc(_auth.currentUser!.uid)
      .snapshots()
      .map((snapshot) => U.User(
          username: snapshot.data()!["name"],
          email: snapshot.data()!["email"],
          id: snapshot.data()!["id"],
          gender: snapshot.data()!["gender"],
          image: snapshot.data()!["image"]));
  @override
  bool isLogedIn() {
    return _auth.currentUser != null;
  }

  @override
  Future<void> logOut() {
    return _auth.signOut();
  }

  @override
  Future<void> updateUserProfile(U.User user) async {
    return await _auth.currentUser!
        .updateProfile(displayName: user.username, photoURL: user.image);
  }

  @override
  Future<void> updateUserEmail(String newEmail) async {
    return await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
  }
}
