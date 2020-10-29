import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kuku/utils/constant.dart';
import 'package:meta/meta.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signIn(String email, String password);
  Future<String> signInWithGoogle();
  Future<String> signInWithFacebook();
  Future<void> signUp(String name, String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<void> sendPasswordResetEmail({@required String email});
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth implements BaseAuth {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  @override
  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  @override
  Future<String> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return user.uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final User user = userCredential.user;
    if (userCredential.additionalUserInfo.isNewUser) {
      createRecord(user.displayName, user.uid);
    }

    Constant.useruid = user.uid;
    return 'success';
  }

  @override
  Future<String> signInWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();

    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken.token);

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = userCredential.user;

      if (userCredential.additionalUserInfo.isNewUser) {
        createRecord(user.displayName, user.uid);
      }
      Constant.useruid = user.uid;
      return 'success';
    } else if (result.status == FacebookLoginStatus.cancelledByUser) {
      print('Login cancelled by the user.');
      return 'canceled';
    } else if (result.status == FacebookLoginStatus.error) {
      print('login with fb error: ' + result.errorMessage.toString());
      return result.errorMessage;
    } else {
      return 'Unexpected error';
    }
  }

  @override
  Future<void> signUp(String name, String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    Constant.useruid = userCredential.user.uid;
    createRecord(name, userCredential.user.uid);
  }

  @override
  Future<User> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User user = await _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  void createRecord(name, uid) async {
    db.collection("users").doc(uid).set({'name': name});
    db
        .collection("users")
        .doc(uid)
        .collection("setting")
        .doc('themesetting')
        .set({
      'unlockTheme': [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false,
        false
      ]
    });
  }

  @override
  Future<void> sendPasswordResetEmail({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
