
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  final googlesignin = GoogleSignIn();
  bool _isSigningin = false;

  GoogleSignInProvider() {
    _isSigningin = false;
  }
  bool get isSigningin => _isSigningin;
  set isSigningin(bool isSigninigin) {
    _isSigningin = isSigninigin;
    notifyListeners();
  }

  Future login() async {
    print('here');
    isSigningin = true;
    final user = await googlesignin.signIn();
    if (user == null) {
      isSigningin = false;
      return;
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      isSigningin = false;
    }
  }

  void logout() async {
    await googlesignin.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
