import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signIn(String email, String password);
  Future<String> signInWithGoogle();
  Future<String> signInWithFacebook();
  Future<String> signUp(String email, String password);
  Future<User> getCurrentUser();
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth implements BaseAuth {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Stream<String> get onAuthStateChanged {
    // return _firebaseAuth.onAuthStateChanged
    //     .map((FirebaseUser user) => user?.uid);
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }

  @override
  Future<String> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
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
      createRecord(user);
    }

    return user.uid;
  }

  @override
  Future<String> signInWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();

    print('before fb login');
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    print('after fb login');

    try {
      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);

        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final User user = userCredential.user;

        if (userCredential.additionalUserInfo.isNewUser) {
          createRecord(user);
        }

        return user.uid;
      } else if (result.status == FacebookLoginStatus.cancelledByUser) {
        print('Login cancelled by the user.');
        return 'canceled';
      } else if (result.status == FacebookLoginStatus.error) {
        print('login with fb error: ' + result.errorMessage.toString());
        return 'error';
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print(e.message);
//       authProblems errorType;
//       if (Platform.isAndroid) {
//   switch (e.message) {
//     case 'There is no user record corresponding to this identifier. The user may have been deleted.':
//       errorType = authProblems.UserNotFound;
//       Utils.showToast(errorType.toString());
//       break;
//     case 'The password is invalid or the user does not have a password.':
//       errorType = authProblems.PasswordNotValid;
//       break;
//     case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
//       errorType = authProblems.NetworkError;
//       break;
//     // ...
//     default:
//       print('Case ${e.message} is not jet implemented');
//   }
// } else if (Platform.isIOS) {
//   switch (e.code) {
//     case 'Error 17011':
//       errorType = authProblems.UserNotFound;
//       break;
//     case 'Error 17009':
//       errorType = authProblems.PasswordNotValid;
//       break;
//     case 'Error 17020':
//       errorType = authProblems.NetworkError;
//       break;
//     // ...
//     default:
//       print('Case ${e.message} is not jet implemented');
//   }
// }
    }
  }

  @override
  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    return user.uid;
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

  void createRecord(User userdata) async {
    await db.collection("users").doc(userdata.uid).set({
      'name': userdata.displayName,
      'email': userdata.email,
    });
  }
}
