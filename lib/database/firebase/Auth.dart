import 'package:notes/_appPackages.dart';
import 'package:notes/_externalPackages.dart';
import 'package:notes/_internalPackages.dart';

class Auth with ChangeNotifier {
  Auth() : isLoggedIn = false {
    logger.i('Auth Const');

    isLoggedIn = auth.currentUser != null;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  bool isLoggedIn;

  Future<String> signInWithPassword(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (auth.currentUser != null) {
        isLoggedIn = auth.currentUser!.emailVerified;
      }
      if (!isLoggedIn) {
        unawaited(auth.currentUser!.delete());
      }
      return isLoggedIn ? 'success' : 'user-not-found';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } finally {
      notifyListeners();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      await auth.signInWithCredential(credential);
      isLoggedIn = true;
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<String> forgetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      isLoggedIn = false;
      notifyListeners();
      return 'success';
    } on FirebaseAuthException catch (e, __) {
      return e.code;
    } finally {
      notifyListeners();
    }
  }

  Future<String> singUp({required NotesUser user}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      await auth.currentUser!.sendEmailVerification();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } finally {
      notifyListeners();
    }
  }
}
